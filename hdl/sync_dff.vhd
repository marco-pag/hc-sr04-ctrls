-------------------------------------------------------------------------------
--
-- Double flip-flop synchronizer
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

entity sync_dff is
    port (
        reset_n : in std_logic;
        clk : in std_logic;
        async_in : in std_logic;
        sync_out : out std_logic
    );
end entity;

architecture rtl of sync_dff is
    signal meta : std_logic;
begin  
    synchronizer : process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                meta <= '0';
                sync_out <= '0';
            else
                meta <= async_in;
                sync_out <= meta;
            end if;
        end if;
    end process;
end architecture;
