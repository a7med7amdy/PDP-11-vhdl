LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity loadFromNextAddress is
    port(
        F6 : IN std_logic_vector(1 DOWNTO 0);
        NextAddressField : IN std_logic_vector(4 DOWNTO 0);
        M : IN std_logic_vector(2 DOWNTO 0);
        Sbit : IN std_logic;
        AddOut   : OUT std_logic_vector(4 DOWNTO 0));
end loadFromNextAddress;

architecture arch of loadFromNextAddress is
    COMPONENT mux4 IS
    PORT( in0,in1,in2,in3: IN std_logic;
    sel : IN std_logic_vector (1 DOWNTO 0);
    out1: OUT std_logic);
    END COMPONENT ;
-------------------------------------------------------------------
    COMPONENT mux2 IS
    PORT (IN1,IN2,SEl	:  IN std_logic;
            OUT1        : OUT  std_logic); 
    END COMPONENT ;
-------------------------------------------------------------------
COMPONENT mux2_3bit IS
PORT (IN1,IN2   :  IN std_logic_vector(2 DOWNTO 0);
        SEl	    :  IN std_logic;
    OUT1        : OUT  std_logic_vector(2 DOWNTO 0));   
END COMPONENT ;
-------------------------------------------------------------------
    signal  muxout,auxNor : std_logic;
    signal  N0new,N0new2 : std_logic;
    signal  selAux1,selAux2 : std_logic;

begin
auxNor <= not(M(0) or M(1) or M(2));
u0: mux4 PORT MAP (NextAddressField(0),Sbit,auxNor,M(2),F6,muxout);
N0new <= N0new or muxout;
N0new2 <= N0new or Sbit;
selAux1 <= F6(0) or F6(1) or NextAddressField(0);
selAux2 <= F6(0) or F6(1) or not(NextAddressField(0));
u1: mux2 PORT MAP (N0new,N0new2,selAux2,AddOut(0));
u2: mux2_3bit PORT MAP ("000",NextAddressField(3 DOWNTO 1),selAux1,AddOut(3 DOWNTO 1));
AddOut(4) <= NextAddressField(4);
end arch ; -- arch
