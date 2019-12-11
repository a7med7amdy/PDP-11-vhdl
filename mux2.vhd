LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux2 IS  
		PORT (IN1,IN2,SEl	:  IN std_logic;
  		            OUT1        : OUT  std_logic);    
END ENTITY mux2;


ARCHITECTURE Data_flow OF mux2 IS
BEGIN
     
   out1 <= (in1 and (not Sel)) 
                     or 
                     (in2 and Sel);
END Data_flow;

------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux2_3bit IS  
      PORT (IN1,IN2  :  IN std_logic_vector(2 DOWNTO 0);
            SEl	:  IN std_logic;
  		      OUT1        : OUT  std_logic_vector(2 DOWNTO 0));    
END ENTITY mux2_3bit;


ARCHITECTURE Data_flow OF mux2_3bit IS
BEGIN
     
out1 <=   IN1 WHEN SEl = '0' 
              ELSE IN2;

END Data_flow;