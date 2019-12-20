LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux2_5bit IS  
      PORT (IN1,IN2  :  IN std_logic_vector(4 DOWNTO 0);
            SEl	:  IN std_logic;
  	    OUT1        : OUT  std_logic_vector(4 DOWNTO 0));    
END ENTITY mux2_5bit;

library ieee;
use ieee.std_logic_1164.all;

Entity S_bit IS
port   ( SRCin,Op1,Clk,rst: IN std_logic;
	  Q: OUT std_logic);
end S_bit;

Architecture S_BitBehavior of S_bit is
signal prompt,feedback :std_logic;
begin

prompt <=SRCin or Op1 or feedback;
U0: entity work.my_DFF port map(prompt,Clk,rst,feedback);
Q<=feedback;
end S_BitBehavior;
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

Entity ControlUnitComplete IS
port (  IR : IN std_logic_vector (15 Downto 0);
	--M0 : IN std_logic_vector (2 Downto 0);
	Clk,Rst:  IN std_logic ;
	BR,HLT,OneOP : OUT std_logic;
	Reg : OUT std_logic_vector(2 downto 0);
	MPC : OUT std_logic_vector(4 Downto 0));
end ControlUnitComplete;

Architecture Decoding_Circuit of ControlUnitComplete is
--Some of wires are signals(utility), others are output
signal SRCin,op1,SBit,PLAout : std_logic;
signal F6 :std_logic_vector(1 downto 0 );
signal F0 : std_logic_vector(4 downto 0 ); 
signal nextAddress1 : std_logic_vector(4 downto 0 ); 
signal nextAddress2 : std_logic_vector(4 downto 0 );
signal M0 : std_logic_vector(2 downto 0);
begin

	N0:entity work.S_bit port map(SRCin,op1,Clk,Rst,SBit);
	N1:entity work.LoadFromPLA port map(IR,M0,SBit,BR,HLT,OneOP,nextAddress1);
	N2:entity work.mux2_3bit port map(IR(11 downto 9), IR(5 downto 3),SBit,M0);
	N3:entity work.loadFromNextAddress port map(F6,F0,M0,SBit,nextaddress2);
	N4:entity work.mux2_5bit port map(nextaddress2,nextaddress1,PLAout,MPC);

	N: entity work.mux2_3bit port map(IR(8 downto 6), IR(2 downto 0),SBit,Reg);
end Decoding_Circuit;
