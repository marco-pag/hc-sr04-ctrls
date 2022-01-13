-------------------------------------------------------------------------------
--
-- One shot timer
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

entity base_timer is
    generic (
        TIMER_BITS : natural := 32
    );
    port (
        reset_n : in std_logic;
        clk : in std_logic;
        -- Timer control
        run_in : in std_logic;
        -- Timer divider
        div_in : in std_logic_vector(TIMER_BITS - 1 downto 0);
        count_out : out std_logic_vector(TIMER_BITS - 1 downto 0)
    );
end entity;

architecture behavioral of base_timer is
    signal count : unsigned(TIMER_BITS - 1 downto 0);
    signal div : unsigned(TIMER_BITS - 1 downto 0);
begin
    count_out <= std_logic_vector(count); 
    
    control : process(clk)
        variable ticks : unsigned(TIMER_BITS - 1 downto 0);
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                ticks := (others => '0');
                count <= (others => '0');
                div <= (others => '0');
            else
                if run_in = '0' then
                    ticks := (others => '0');
                    count <= (others => '0');
                    -- Sample the divider before starting
                    div <= unsigned(div_in);
                else
                    if ticks < unsigned(div) then
                        ticks := ticks + 1;
                    else
                        ticks := (others => '0');
                        count <= count + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture;
