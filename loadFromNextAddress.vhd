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

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

architecture arch of loadFromNextAddress is
    COMPONENT mux4 IS
    PORT( in0,in1,in2,in3: IN std_logic;
    sel : IN std_logic_vector (1 DOWNTO 0);
    out1: OUT std_logic);
    END COMPONENT;
-------------------------------------------------------------------
    COMPONENT mux2 IS
    PORT (IN1,IN2,SEl	:  IN std_logic;
            OUT1        : OUT  std_logic); 
    END COMPONENT; 
-------------------------------------------------------------------
COMPONENT mux2_3bit IS
PORT (IN1,IN2   :  IN std_logic_vector(2 DOWNTO 0);
        SEl	    :  IN std_logic;
    OUT1        : OUT  std_logic_vector(2 DOWNTO 0));   
END COMPONENT ;
-------------------------------------------------------------------
    signal  muxout,auxNor : std_logic;
    signal  N0new,N0new2 : std_logic;
    signal  selAux : std_logic;

begin
auxNor <= not(M(0) or M(1) or M(2));
u0: mux4 PORT MAP (NextAddressField(0),Sbit,auxNor,M(2),F6,muxout);
N0new <= NextAddressField(0) or muxout;
N0new2 <= N0new or Sbit;
selAux <= F6(0) and F6(1) and N0new;
u1: mux2 PORT MAP (N0new,N0new2,selAux,AddOut(0));
u2: mux2_3bit PORT MAP (NextAddressField(3 DOWNTO 1),"000",selAux,AddOut(3 DOWNTO 1));
AddOut(4) <= NextAddressField(4);
end arch ; -- arch
