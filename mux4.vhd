LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux4_1bit IS
PORT( in0,in1,in2,in3: IN std_logic;
              sel : IN std_logic_vector (1 DOWNTO 0);
              out1: OUT std_logic);
END mux4_1bit;


ARCHITECTURE  arch1 OF mux4_1bit IS
BEGIN
        out1 <=   in0 WHEN sel(0) = '0' AND sel(1) ='0'
            ELSE in1 WHEN   sel(0) = '0' AND sel(1) ='1'
            ELSE in2 WHEN   sel(0) = '1' AND sel(1) ='0'
            ELSE in3;

END arch1;

----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY mux4_2bit IS
PORT( in0,in1,in2,in3: IN std_logic_vector (1 DOWNTO 0);
              sel0,sel1 : IN std_logic;
              out1: OUT std_logic_vector (1 DOWNTO 0));
END mux4_2bit;


ARCHITECTURE  arch2 OF mux4_2bit IS
BEGIN
        out1 <=   in0 WHEN sel0 = '0' AND sel1 ='0'
            ELSE in1 WHEN   sel0 = '0' AND sel1 ='1'
            ELSE in2 WHEN   sel0 = '1' AND sel1 ='0'
            ELSE in3;

END arch2;
