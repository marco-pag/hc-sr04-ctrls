-------------------------------------------------------------------------------
--
-- Local types
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

package local_types is
    constant NUM_SENSORS_MAX : natural := 8;
    constant D_SIZE : natural := 32;
    type slv32_bus_t is array (natural range <>) of std_logic_vector(D_SIZE-1 downto 0); 
end package;
