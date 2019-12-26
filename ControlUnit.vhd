LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity S_bit IS
port   ( SRCin,Op1,Clk,rst: IN std_logic;
	  Q: OUT std_logic);
end S_bit;

Architecture S_BitBehavior of S_bit is
signal prompt,feedback :std_logic;
begin
	prompt <=SRCin or Op1 or feedback;
	U0: entity work.my_DFF port map(prompt,Clk,rst,feedback);
	Q<=prompt;
end S_BitBehavior;
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

Entity ControlUnitComplete IS
port (  IR : IN std_logic_vector (15 Downto 0);
	--M0 : IN std_logic_vector (2 Downto 0);
	Clk,RST:  IN std_logic;
	BR,HLT : OUT std_logic;
	Reg : OUT std_logic_vector(2 downto 0);
	PCout,MDRout,Zout,Rout,SPout,SOURCEout,PCin,SPin,ADD,Rin,SUB,Yin,MDRin,SOURCEin,MARin,IRin,RD,WR,CARRYin: OUT std_logic;
	operation: out std_logic_vector(4 downto 0);
	next1,next2,inp,mpc: out std_logic_vector(4 downto 0);
	pl:out std_logic;
	cww: out std_logic_vector(18 downto 0));
end ControlUnitComplete;

Architecture Decoding_Circuit of ControlUnitComplete is
--Some of wires are signals(utility), others are output
signal SRCin,op1,SBit,PLAout,ResetSbit : std_logic;
signal nextAddress1 : std_logic_vector(4 downto 0 ); 
signal nextAddress2 : std_logic_vector(4 downto 0 );
signal M0 : std_logic_vector(2 downto 0);
signal MPCin: std_logic_vector(4 downto 0);
signal MPCout: std_logic_vector(4 downto 0);
signal CW: std_logic_vector(18 downto 0);
begin
	ResetSbit<=not(MPCout(0)) and not(MPCout(1)) and not(MPCout(2)) and not(MPCout(3)) and not(MPCout(4)); 
	N0:entity work.S_bit port map(SRCin,op1,Clk,ResetSbit,SBit); 
	N1:entity work.LoadFromPLA port map(IR,M0,SBit,HLT,op1,nextAddress1,operation);
	N2:entity work.mux2_3bit port map(IR(11 downto 9), IR(5 downto 3),SBit,M0);
	N3:entity work.loadFromNextAddress port map(CW(1 downto 0),CW(17 downto 13),M0,SBit,nextaddress2);
	N11:entity work.reg5 port map(MPCin,Clk,RST,MPCout);
	N4:entity work.mux2_5bit port map(nextaddress2,nextaddress1,PLAout,MPCin);
	N5:entity work.rom port map(MPCout,CW);
	
	N7:entity work.Decoder3Bit port map(CW(12 downto 10),PCout,MDRout,Zout,Rout,SPout,SOURCEout);  --F1 signals
	N8:entity work.Decoder3Bit port map(CW(9 downto 7),PCin,SPin,ADD,Rin,SUB,Yin,MDRin); --F2 signals
	N9:entity work.Decoder2Bit port map(CW(6 downto 5),SRCin,MARin,IRin); --F3 signals
       N10:entity work.Decoder2Bit port map(CW(4 downto 3),RD,WR,PLAout); --F4 signals


	CARRYin<=CW(2);  --F5 signal
	br<=CW(18);
	SOURCEin<=SRCin;


	next1<=nextAddress1;
	next2<=nextaddress2;
	inp<=MPCin;
	pl<=PLAout;
	mpc<=MPCout;
	cww<=CW;

	N: entity work.mux2_3bit port map(IR(8 downto 6), IR(2 downto 0),SBit,Reg);
end Decoding_Circuit;
