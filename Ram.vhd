LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.numeric_std.all;

ENTITY ram IS

PORT (clk : IN std_logic;
we : IN std_logic;
address : IN std_logic_vector(11 DOWNTO 0);
datain : IN std_logic_vector(15 DOWNTO 0);
dataout : OUT std_logic_vector(15 DOWNTO 0) );
END ENTITY ram;

ARCHITECTURE sync_ram_a OF ram IS

TYPE ram_type IS ARRAY(0 TO 4095) of std_logic_vector(15 DOWNTO 0);

SIGNAL ram : ram_type := (
 0=> "1111100100000000",
 1=> "1111100100000000",
 2=> "1111100100000000",
 3=> "0000001111000001",
 4=> "0000000000000001",
 5=> "0000001111000010",
 6=> "0000000000000010",
 7=> "0000001111000011",
 8=> "0000000000000011",
 9=> "0000001111000100",
 10=> "0000000000000100",
 11=> "0000001111000101",
 12=> "0000000000000101",
 13=> "1011001000000001",
 14=> "1010101000000010",
 15=> "1010011000000011",
 16=> "1010010000000100",
 17=> "1101000000000001",
 18=> "1010000000000101",
 19=> "1111101000000000",
 20=> "0000000000010001",
 21=> "1101000011110011",
 22=> "0001000001000010",
 23=> "1111100100000000",
 24=> "1111101100000000",
 others=>X"0000"
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
