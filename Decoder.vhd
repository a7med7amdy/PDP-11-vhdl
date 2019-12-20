LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Decoder is
	port(s0,s1,En : IN std_logic;
	     d : out std_logic_vector (1 to 4));
end Decoder;

architecture dec of Decoder is
begin
	process(s0,s1,En)
	begin
		if(En='0') then
		       d<="0000";
		elsif (s0='0' and s1='0') then
		       d<="1000";

		elsif (s0='1' and s1='0') then
		       d<="0100";
		   
		elsif (s0='0' and s1='1') then
		       d<="0010";
		       
		elsif (s0='1' and s1='1') then
		       d<="0001";
		end if;
	end process;
end dec;