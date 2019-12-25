LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.numeric_std.all;

ENTITY ram IS

PORT (clk : IN std_logic;
we : IN std_logic;
address : IN std_logic_vector(4 DOWNTO 0);
datain : IN std_logic_vector(15 DOWNTO 0);
dataout : OUT std_logic_vector(15 DOWNTO 0) );
END ENTITY ram;

ARCHITECTURE sync_ram_a OF ram IS

TYPE ram_type IS ARRAY(0 TO 4095) of std_logic_vector(15 DOWNTO 0);

SIGNAL ram : ram_type := (
 0=> "0000001111000001",
 1=> "0000000000001001",
 2=> "1111100100000000",
 3=> "1111100100000000",
 4=> "1111100100000000",
 5=> "1111100100000000",
 6=> "1111100100000000",
 7=> "0000001111000000",
 8=> "0000000000001000",
 9=> "0000001111000010",
 10=> "0000000000000010",
 11=> "1111100000000000",
 12=> "0000011111000011",
 13=> "0000000000000000",
 OTHERS => X"0000"
);

BEGIN

PROCESS(clk) IS

BEGIN

IF rising_edge(clk) THEN

IF we = '1' THEN

ram(to_integer(unsigned((address)))) <= datain;

END IF;

END IF;

END PROCESS;

dataout <= ram(to_integer(unsigned((address))));

END sync_ram_a;
