library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity BranchingCirc is
	port(PCin,IR,FlagReg : IN std_logic_vector(15 Downto 0);
	     PCout : out std_logic_vector (15 Downto 0));
end BranchingCirc;

architecture BranchingCircArch of BranchingCirc is
    component Adder_bits_n IS    
    PORT (    
        a, b  :  IN  std_logic_vector(15 downto 0);
        Ci   :  IN  std_logic; 
        S     :  OUT std_logic_vector(15 downto 0);
        Co  :  OUT std_logic;
        V     :  OUT std_logic  );  
    end component;
---------------------------------------------------------------
    component mux2_16bit IS  
      PORT (IN1,IN2  :  IN std_logic_vector(15 DOWNTO 0);
            SEl	:  IN std_logic;
          OUT1        : OUT  std_logic_vector(15 DOWNTO 0)); 
    end component;
---------------------------------------------------------------
    signal Carry,Zero,condition,uselessC,uselessV : std_logic;
    signal selector : std_logic_vector(2 Downto 0);
    signal helpWithSign : std_logic_vector(8 Downto 0); -- 9 bits
    --signal offset : signed(15 downto 0);
    signal OP2,offset : std_logic_vector(15 Downto 0);
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
    helpWithSign <= (others => IR(7));
    offset <= helpWithSign(8 Downto 0) & IR(6 Downto 0); --extend with sign
    ADD: Adder_bits_n PORT MAP(offset,PCin,'0',OP2,uselessC,uselessV);
    --OP2 <= signed(offset) + unsigned(PCin);
    M: mux2_16bit PORT MAP (Pcin,OP2,condition,PCout);

end BranchingCircArch;