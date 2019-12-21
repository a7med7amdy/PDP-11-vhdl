LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Decoder2Bit is
	port(   s : in std_logic_vector(0 to 1);
	        d1,d2,d3 : out std_logic);
end Decoder2Bit;

architecture dec of Decoder2Bit is
begin
	process(s)
	begin
		if (s(0)='0' and s(1)='0') then
		        d1<='0';
			d2<='0';
			d3<='0';

		elsif (s(0)='0' and s(1)='1') then
		        d1<='1';
			d2<='0';
			d3<='0';
		   
		elsif (s(0)='1' and s(1)='0') then
		        d1<='0';
			d2<='1';
			d3<='0';
		       
		elsif (s(0)='1' and s(1)='1') then
		        d1<='0';
			d2<='0';
			d3<='1';
		end if;
	end process;
end dec;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity Decoder3Bit is
	port(   s : in std_logic_vector(0 to 2);
	        d1,d2,d3,d4,d5,d6,d7 : out std_logic);
end Decoder3Bit;

architecture dec of Decoder3Bit is
begin
	process(s)
	begin
		if (s(0)='0' and s(1)='0' and s(2)='0') then
		        d1<='0';
			d2<='0';
			d3<='0';
			d4<='0';
			d5<='0';
			d6<='0';
			d7<='0';

		elsif (s(0)='0' and s(1)='0' and s(2)='1') then
		        d1<='1';
			d2<='0';
			d3<='0';
			d4<='0';
			d5<='0';
			d6<='0';
			d7<='0';
		   
		elsif (s(0)='0' and s(1)='1' and s(2)='0') then
		        d1<='0';
			d2<='1';
			d3<='0';
			d4<='0';
			d5<='0';
			d6<='0';
			d7<='0';
		       
		elsif (s(0)='0' and s(1)='1' and s(2)='1') then
		        d1<='0';
			d2<='0';
			d3<='1';
			d4<='0';
			d5<='0';
			d6<='0';
			d7<='0';

		elsif (s(0)='1' and s(1)='0' and s(2)='0') then
		        d1<='0';
			d2<='0';
			d3<='0';
			d4<='1';
			d5<='0';
			d6<='0';
			d7<='0';

		elsif (s(0)='1' and s(1)='0' and s(2)='1') then
		        d1<='0';
			d2<='0';
			d3<='0';
			d4<='0';
			d5<='1';
			d6<='0';
			d7<='0';
		   
		elsif (s(0)='1' and s(1)='1' and s(2)='0') then
		        d1<='0';
			d2<='0';
			d3<='0';
			d4<='0';
			d5<='0';
			d6<='1';
			d7<='0';
		       
		elsif (s(0)='1' and s(1)='1' and s(2)='1') then
		        d1<='0';
			d2<='0';
			d3<='0';
			d4<='0';
			d5<='0';
			d6<='0';
			d7<='1';
		end if;
	end process;
end dec;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity RegDecoder is
	port(   s : in std_logic_vector(0 to 2);
		E : in std_logic;
	        d : out std_logic_vector(0 to 7));
end RegDecoder;

architecture dec of RegDecoder is
begin
	process(s,E)
	begin
		if (E='0') then 
			d<="00000000";

		elsif (s="000") then
		        d<="10000000";

		elsif (s="001") then
		        d<="01000000";
		   
		elsif (s="010") then
		        d<="00100000";
		       
		elsif (s="011") then
		        d<="00010000";

		elsif (s="100") then
		        d<="00001000";

		elsif (s="101") then
		        d<="00000100";
		   
		elsif (s="110") then
		        d<="00000010";
		       
		elsif (s="111") then
		        d<="00000001";
		end if;
	end process;
end dec;

