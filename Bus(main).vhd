LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

package my_types_pkg is
  type array16 is array (0 to 14) of std_logic_vector(15 downto 0);
end package;
----------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.my_types_pkg.all;

Entity processor is
	PORT( Clk,Rst,INT : IN std_logic); 
end processor;


library ieee;
use ieee.std_logic_1164.all;
library work;
use work.my_types_pkg.all;

architecture MainRoutine of processor is
	--signal bibus,R1,R2,R3,R4,Trin1,Trin2,Trin3,Trin4,Trout1,Trout2,Trout3,Trout4 : std_logic_vector(31 DOWNTO 0);
	--signal En1in,En2in,En3in,En4in,En1out,En2out,En3out,En4out : std_logic;
	signal BR,HLT,ClkM : std_logic;
	signal RegSelect : std_logic_vector(2 downto 0);
	signal PCout,MDRout,Zout,Rout,SPout,SOURCEout,PCin,SPin,ADD,Rin,SUB,Yin,MDRin,SOURCEin,MARin,IRin,RD,WR,CARRYin,Zin : std_logic;
	signal bibus,fromMemory : std_logic_vector(15 DOWNTO 0);
	signal R,Trin,Trout : array16;
	--R0:7  R8-->MAR  R9-->MDR  R10-->IR  R11-->Source  R12-->Y   R13-->Z   R14-->FR
	signal RegEnableIN,RegEnableOUT : std_logic_vector(0 to 7);
	signal EnableIN,EnableOUT : std_logic_vector (0 to 13);
	
begin
	--Memory Clock is opposite to normal one
	ClkM<= not (Clk);
	-----------------------------------------------------------------
	--Control Unit port mapping
	unit: entity work.ControlUnitComplete port map(R(10),Clk,Rst,BR,HLT,RegSelect,PCout,MDRout,Zout,Rout,SPout,SOURCEout,PCin,SPin,ADD,Rin,SUB,Yin,MDRin,SOURCEin,MARin,IRin,RD,WR,CARRYin);
	Zin<= ADD or SOURCEout or CARRYin;
	-----------------------------------------------------------------
	--Register file port mapping
	L0: for i in 0 to 12 generate
		U: entity work.reg16 port map(Trin(i),Clk,Rst,R(i));
	end generate;
        ------------------------------------------------------------------
	--Connect registers to input to the bus
	Input: entity work.RegDecoder port map(RegSelect,Rin,RegEnableIN);
	EnableIN<=RegEnableIN & MARin & MDRin & IRin & SOURCEin & Yin & '0';

	L2: for i in 0 to 12 generate
		Z1: entity work.tri_state_buffer port map (bibus,EnableIN(i),Trin(i));
	end generate;
        -------------------------------------------------------------------
	--Connect registers to take from bus
	Output: entity work.RegDecoder port map(RegSelect,Rout,RegEnableOUT);
	EnableOUT<=RegEnableOUT & '0' & MDRout & '0' & SOURCEout & '0' & Zout;
	L1: for i in 0 to 7 generate
		Y1: entity work.tri_state_buffer port map (R(i),EnableOUT(i),Trout(i));
	end generate;
	forMdrout:entity work.tri_state_buffer port map (R(9),EnableOUT(9),Trout(9));
	forSRCout:entity work.tri_state_buffer port map (R(11),EnableOUT(11),Trout(11));
	forZout  :entity work.tri_state_buffer port map (R(13),EnableOUT(13),Trout(13));
	-------------------------------------------------------------------
	--Raaaaaaaaaaaaaaaaaaaaaaaaam
	L: entity work.ram port map (ClkM,Wr,R(8)(4 DOWNTO 0),R(9),fromMemory);
	Z4: entity work.tri_state_buffer port map (fromMemory,Rd,TRin(9));
	-------------------------------------------------------------------

	process (  Trout )
	begin
		for i in 0 to 13 loop
			if(Trout(i) /="ZZZZZZZZZZZZZZZZ" and Trout(i) /="UUUUUUUUUUUUUUUU") then
			 	bibus<=Trout(i);
			end if;
		end loop;
	end process;
	
End MainRoutine;
