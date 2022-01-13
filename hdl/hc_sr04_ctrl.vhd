-------------------------------------------------------------------------------
--
-- Simple hc-sr04 module controller
-- 
-------------------------------------------------------------------------------
-- 
-- Copyright (C) Marco Pagani, <marco.pag(at)outlook.com>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hc_sr04_ctrl is
    generic (
        CLK_FREQ_HZ : natural := 100e6;
        D_WIDTH : natural := 32
    );
    port (
        reset_n : in std_logic;
        clk : in std_logic;
        -- Sensor
        trig_out : out std_logic;
        echo_in : in std_logic;
        -- Control
        enable_in : in std_logic;
        -- Last measured distance
        dist_out : out std_logic_vector(D_WIDTH - 1 downto 0)
    );
end entity;


architecture behavioral of hc_sr04_ctrl is
    -- Timer size
    constant PULSE_TIMER_BITS : natural := 18;
    constant ECHO_TIMER_BITS : natural := 12;
    -- Clock cycles per us 
    constant CLKS_PER_US : natural := natural(real(CLK_FREQ_HZ) / 1.0e6);
    -- Trigger pulse 10 us
    constant TRIG_US : natural := 10;
    -- Suggested delay between measurements from datasheet: > 60 ms
    constant CYCLE_US : natural := (60 + 10) * 1e3;
    -- Echo pulse ns / mm ratio
    constant NS_PER_MM : natural := 5831;
    -- Clks/mm conversion ratio
    constant CLKS_PER_MM : natural := natural(real(CLK_FREQ_HZ) / 1.0e9 * real(NS_PER_MM));
    -- Echo guard interval / min distance
    constant ECHO_MIN_MM : natural := 15;
    
    -- Echo muted during pulses
    signal trig : std_logic;
    signal echo_muted : std_logic;

    -- Pulse timer
    signal pulse_tim_run : std_logic;
    signal pulse_tim_div : std_logic_vector(PULSE_TIMER_BITS - 1 downto 0);
    signal pulse_tim_count : std_logic_vector(PULSE_TIMER_BITS - 1 downto 0);
    
    -- Echo timer
    signal echo_tim_run : std_logic;
    signal echo_tim_div : std_logic_vector(ECHO_TIMER_BITS - 1 downto 0);
    signal echo_tim_count : std_logic_vector(ECHO_TIMER_BITS - 1 downto 0);
    
begin
    pulse_timer : entity work.base_timer(behavioral)
        generic map (
            TIMER_BITS => PULSE_TIMER_BITS
        )
        port map (
            reset_n => reset_n,
            clk => clk,
            run_in => pulse_tim_run,
            div_in => pulse_tim_div,
            count_out => pulse_tim_count
        );
        
    echo_timer : entity work.base_timer(behavioral)
        generic map (
            TIMER_BITS => ECHO_TIMER_BITS
        )
        port map (
            reset_n => reset_n,
            clk => clk,
            run_in => echo_tim_run,
            div_in => echo_tim_div,
            count_out => echo_tim_count
        );
        
    trig_out <= trig;
    echo_muted <= echo_in and (not trig);
        
    pulse_gen: process(clk)
        type state_t is (IDLE, PULSE);
        variable state : state_t;
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                trig <= '0';
                pulse_tim_run <= '0';
                pulse_tim_div <= std_logic_vector(to_unsigned(CLKS_PER_US, pulse_tim_div'length));
                state := IDLE;
            else
                case state is
                when IDLE =>
                    if enable_in = '1' then
                        -- Start trigger pulse
                        trig <= '1';
                        pulse_tim_run <= '1';
                        state := PULSE;
                    end if;
                when PULSE =>
                    if unsigned(pulse_tim_count) = TRIG_US then
                        trig <= '0';
                    elsif unsigned(pulse_tim_count) = CYCLE_US then
                        pulse_tim_run <= '0';
                        state := IDLE;
                    end if;
                end case;
            end if;
        end if;
    end process;
    
    echo_sense: process(clk)
        type state_t is (ECHO_WAIT, ECHO_CHECK, ECHO_MEASURE);
        variable state : state_t;
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                dist_out <= (others => '0');
                echo_tim_run <= '0';
                echo_tim_div <= std_logic_vector(to_unsigned(CLKS_PER_MM, echo_tim_div'length));
                state := ECHO_WAIT;
            else
                case state is
                when ECHO_WAIT =>
                    if enable_in = '0' then
                        dist_out <= (others => '0');
                    elsif echo_muted = '1' then
                        echo_tim_run <= '1';
                        state := ECHO_CHECK;
                    end if;
                when ECHO_CHECK =>
                    if unsigned(echo_tim_count) = ECHO_MIN_MM then
                        if echo_muted = '1' then
                            state := ECHO_MEASURE;
                        else
                            echo_tim_run <= '0';
                            state := ECHO_WAIT;
                        end if;
                    end if;
                when ECHO_MEASURE =>
                    if echo_muted = '0' then
                        -- Get the distance
                        echo_tim_run <= '0';
                        dist_out <= std_logic_vector(resize(unsigned(echo_tim_count), dist_out'length));
                        state := ECHO_WAIT;
                    end if;
                end case;
            end if;
        end if;
    end process;

end architecture;
