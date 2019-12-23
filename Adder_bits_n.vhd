library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

ENTITY Adder_bits_n IS    
    PORT (    
        a, b  :  IN  std_logic_vector(15 downto 0);
        Ci   :  IN  std_logic; 
        S     :  OUT std_logic_vector(15 downto 0);
        Co  :  OUT std_logic;
        V     :  OUT std_logic  );  
END Adder_bits_n;  


ARCHITECTURE n_arch OF Adder_bits_n IS 
    COMPONENT FullAdder  
        port(
        A , B : in std_logic;
        Cin : in std_logic;
        Sum : out std_logic;
        Cout : out std_logic
        );     
    END COMPONENT;     
    SIGNAL   t:  std_logic_vector(16 downto 0); 
BEGIN     
    t(0) <= Ci; 
    Co <= t(16);    
    V  <= t(16) XOR t(15);
    FA: for i in 0 to 15 generate  
        FA_i: FullAdder PORT MAP (t(i), a(i), b(i), S(i), t(i+1));     
    end generate; 
     
END n_arch; 