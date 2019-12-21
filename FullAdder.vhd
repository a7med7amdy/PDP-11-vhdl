library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
    port(
        A , B : in std_logic;
        Cin : in std_logic;
        Sum : out std_logic;
        Cout : out std_logic
    );
end FullAdder;

architecture archA of FullAdder is
begin
    Sum <= A XOR B XOR Cin;
    Cout <= ( A AND B) OR ( B AND Cin) OR (Cin AND A);
end archA;