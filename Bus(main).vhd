LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

package my_types_pkg is
  type array32 is array (1 to 6) of std_logic_vector(15 downto 0);
end package;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY my_DFF IS

	PORT( d,clk,rst : IN std_logic; q : OUT std_logic);

END my_DFF;

ARCHITECTURE a_my_DFF OF my_DFF IS

BEGIN

	PROCESS(clk,rst)

	BEGIN

	IF(rst = '1') THEN

	q <= '0';

	ELSIF clk'event and clk = '1' THEN
		if(d/='Z') then
		q <= d;
		end if;
	END IF;

	END PROCESS;

END a_my_DFF;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Reg1 IS

GENERIC ( n : integer := 16);

	PORT( Clk,Rst : IN std_logic;

	d : IN std_logic_vector(n-1 DOWNTO 0);

	q : OUT std_logic_vector(n-1 DOWNTO 0));

END Reg1;

library ieee;
use ieee.std_logic_1164.all;

ARCHITECTURE b_my_nDFF OF Reg1 IS

COMPONENT my_DFF IS

	PORT( d,Clk,Rst : IN std_logic;
	q : OUT std_logic);

END COMPONENT;

BEGIN

loop1: FOR i IN 0 TO n-1 GENERATE

fx: my_DFF PORT MAP(d(i),Clk,Rst,q(i));

END GENERATE;

END b_my_nDFF;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_state_buffer is
    Port (
           -- 16 input / output buffer with one enable
           INp  : in  STD_LOGIC_VECTOR (15 downto 0);
           EN  : in  STD_LOGIC;
           OUTp : out STD_LOGIC_VECTOR (15 downto 0));
end tri_state_buffer;

architecture Behavioral of tri_state_buffer is

begin
    -- 16 input/output active low enabled tri-state buffer
    OUTp <= INp when (EN = '1') else (OTHERS=>'Z');

end Behavioral;

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
			 
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.my_types_pkg.all;

Entity processor is
	PORT( Clk,ClkM,Rst,S0in,S1in,S0out,S1out,EnDin,EnDout,MDRin,MDRout,MARin,MARout,Rd,Wr : IN std_logic;
	
	  Q : OUT array32) ;   
end processor;


library ieee;
use ieee.std_logic_1164.all;

architecture MainRoutine of processor is
	component Reg1 IS
		GENERIC ( n : integer := 16);
		PORT( Clk,Rst : IN std_logic;
		d : IN std_logic_vector(n-1 DOWNTO 0);
		q : OUT std_logic_vector(n-1 DOWNTO 0));
	END component;
	component Decoder is
	port(s0,s1,En : IN std_logic;
	     d: out std_logic_vector (1 to 4));
	end component;
	component tri_state_buffer is
    	Port (
           -- 32 input / output buffer with one enable
           INp  : in  STD_LOGIC_VECTOR (15 downto 0);
           EN  : in  STD_LOGIC;
           OUTp : out STD_LOGIC_VECTOR (15 downto 0));
	end component;

	--signal bibus,R1,R2,R3,R4,Trin1,Trin2,Trin3,Trin4,Trout1,Trout2,Trout3,Trout4 : std_logic_vector(31 DOWNTO 0);
	--signal En1in,En2in,En3in,En4in,En1out,En2out,En3out,En4out : std_logic;
	signal bibus,fromMemory : std_logic_vector(15 DOWNTO 0);
	signal R,Trin,Trout : array32;
	signal EnableIN,EnableOUT : std_logic_vector (1 to 4);
	
begin

	L: entity work.ram port map (ClkM,Wr,R(5)(5 DOWNTO 0),R(6),fromMemory);

	L0: for i in 1 to 6 generate
	U:  Reg1 port map(Clk,Rst,Trin(i),R(i));
	end generate;
	
	process (R)
	begin
		for i in 1 to 6 loop
		Q(i)<=R(i);
		end loop;
	end process;
	X1: Decoder port map(S0in,S1in,EnDin,EnableIN);
	X2: Decoder port map(S0out,S1out,EnDout,EnableOUT);

	L1: for i in 1 to 4 generate
	Y1: tri_state_buffer port map (R(i),EnableOUT(i),Trout(i));
	end generate;

	Y2: tri_state_buffer port map (R(5),MARout,Trout(5));
	Y3: tri_state_buffer port map (R(6),MDRout,Trout(6));

	L2: for i in 1 to 4 generate
	Z1: tri_state_buffer port map (bibus,EnableIN(i),Trin(i));
	end generate;

	Z2: tri_state_buffer port map (bibus,MARin,Trin(5));
	Z3: tri_state_buffer port map (bibus,MDRin,Trin(6));

	Z4: tri_state_buffer port map (fromMemory,Rd,TRin(6));


	process (  Trout )
	begin
		for i in 1 to 6 loop
		if(Trout(i) /="ZZZZZZZZZZZZZZZZ") then
			 bibus<=Trout(i);
		end if;
		end loop;
	end process;
	
End MainRoutine;
