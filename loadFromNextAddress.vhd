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
    component mux2_4bit IS  
      PORT (IN1,IN2  :  IN std_logic_vector(3 DOWNTO 0);
            SEl	:  IN std_logic;
  		      OUT1        : OUT  std_logic_vector(3 DOWNTO 0));    
    END component ;
-------------------------------------------------------------------
    COMPONENT mux4_1bit IS
    PORT( in0,in1,in2,in3: IN std_logic;
                sel : IN std_logic_vector (1 DOWNTO 0);
                out1: OUT std_logic);
    END COMPONENT;
---------------------------------------------------------------------
    signal  muxout,auxNor,regDir : std_logic;
    signal  N0new,N0new2 : std_logic;
    signal  selAux : std_logic;

begin
auxNor <= M(0) or M(1) or M(2);
regDir<=not(M(2));
u0: mux4_1bit PORT MAP (NextAddressField(0),Sbit,auxNor,regDir,F6,muxout);
N0new <= NextAddressField(0) or muxout;
N0new2 <= N0new and Sbit;
selAux <= F6(0) and F6(1) and N0new;
u1: mux2 PORT MAP (N0new,N0new2,selAux,AddOut(0));
u2: mux2_4bit PORT MAP (NextAddressField(4 DOWNTO 1),"1000",selAux,AddOut(4 DOWNTO 1));
end arch ; -- arch
