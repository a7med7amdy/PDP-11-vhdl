LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity BranchingCirc is
	port(PCin,IR,FlagReg : IN std_logic_vector(15 Downto 0);
	     PCput : out std_logic_vector (15 Downto 0));
end BranchingCirc;

architecture BranchingCircArch of BranchingCirc is
    component adder_bits_16 is
        port(
            a,b : IN std_logic_vector(15 DOWNTO 0);
            Cin : IN std_logic;
            S   : OUT std_logic_vector(15 DOWNTO 0);
            Cout : OUT std_logic);
    end component;
    component mux2_16bit IS  
      PORT (IN1,IN2  :  IN std_logic_vector(15 DOWNTO 0);
            SEl	:  IN std_logic;
          OUT1        : OUT  std_logic_vector(15 DOWNTO 0)); 
    end component;
  
    signal Carry,Zero,condition,uselessC : std_logic;
    signal selector : std_logic_vector(2 Downto 0);
    signal offset,OP2 : std_logic_vector(15 Downto 0);
begin
	process(IR,FlagReg)
	begin
        Carry <= FlagReg(0);
        Zero <= FlagReg(1);
        selector <= IR(13 Downto 11);
    if (selector ="000") then
        condition<= '1';
    elsif (selector ="001") then
        condition<= Zero;
    elsif (selector ="010") then
        condition<= not(Zero);
    elsif (selector ="011") then
        condition<= not(Carry);
    elsif (selector ="100") then
        condition<= not(Carry) or Zero;
    elsif (selector ="101") then
        condition<= Carry;
    elsif (selector ="110") then
        condition<= Carry or Zero;
    end if ;
    end process;
    
    offset <= "0000000"&IR(7 Downto 0)&'0';
    ADD: adder_bits_16 PORT MAP(offset,PCin,'0',OP2,uselessC);
    M: mux2_16bit PORT MAP (Pcin,OP2,condition,PCout);

end BranchingCircArch;