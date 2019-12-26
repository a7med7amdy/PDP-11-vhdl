LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity reg16 is
    port(
        d : IN std_logic_vector(15 DOWNTO 0);
        Clk,Rst : IN std_logic;
        q   : OUT std_logic_vector(15 DOWNTO 0));
end reg16;

ARCHITECTURE arch OF reg16 IS
BEGIN
--PROCESS (Clk,Rst)
--BEGIN
--IF Rst = '1' THEN
--		q <= (OTHERS=>'0');
--ELSIF clk'event and clk = '1' THEN
--		if d /="ZZZZZZZZZZZZZZZZ" then
--			q <= d;
--		end if;
process (d,rst)
begin
if rst = '1' then
	q <= (OTHERS=>'0');
elsif d/="ZZZZZZZZZZZZZZZZ" then
	q<=d;

END IF;
END PROCESS;
END arch;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity reg5 is
    port(
        d : IN std_logic_vector(4 DOWNTO 0);
        Clk,Rst : IN std_logic;
        q   : OUT std_logic_vector(4 DOWNTO 0));
end reg5;

ARCHITECTURE arch OF reg5 IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
		q <= (OTHERS=>'0');
ELSIF rising_edge(Clk) THEN
		q<=d;
END IF;
END PROCESS;
END arch;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity regSP is
    port(
        d : IN std_logic_vector(15 DOWNTO 0);
        Clk,Rst : IN std_logic;
        q   : OUT std_logic_vector(15 DOWNTO 0));
end regSP;

ARCHITECTURE arch OF regSP IS
BEGIN
PROCESS (d,Rst)
BEGIN
IF Rst = '1' THEN
		q <= (OTHERS=>'1');
ELSif d /="ZZZZZZZZZZZZZZZZ" then
	q <= d;
END IF;
END PROCESS;
END arch;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity regFR is
    port(
        d : IN std_logic_vector(15 DOWNTO 0);
        Clk,Rst : IN std_logic;
        q   : OUT std_logic_vector(15 DOWNTO 0));
end regFR;




ARCHITECTURE arch OF regFR IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
		q <= (OTHERS=>'0');
ELSIF rising_edge(Clk) THEN
		q<=d;
END IF;
END PROCESS;
END arch;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity regPC is
    port(
        d,brd : IN std_logic_vector(15 DOWNTO 0);
        Clk,Rst,br : IN std_logic;
        q   : OUT std_logic_vector(15 DOWNTO 0));
end regPC;

ARCHITECTURE arch OF regPC IS
BEGIN
PROCESS (d,Rst,br)
BEGIN
IF Rst = '1' THEN
		q <= (OTHERS=>'0');
elsif br = '1' then
	q<=brd;
ELSif d /="ZZZZZZZZZZZZZZZZ" then
	q <= d;
END IF;
END PROCESS;
END arch;
