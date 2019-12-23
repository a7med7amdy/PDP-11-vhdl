library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        src , dest    : in std_logic_vector(15 downto 0);
        operation     : in std_logic_vector(4 downto 0);
        signal_add    : in std_logic;
        signal_sub    : in std_logic;
        Cin           : in std_logic;
	    flag          : in std_logic_vector(4 downto 0);
        flag_reg      : out std_logic_vector(4 downto 0);
        Z             : inout std_logic_vector(15 downto 0)
    );
end ALU;

architecture arch of ALU is
    COMPONENT Adder_bits_n   
	PORT (    
            a, b  :  IN  std_logic_vector(15 downto 0);
            Ci    :  IN  std_logic; 
            S     :  OUT std_logic_vector(15 downto 0);
            Co    :  OUT  std_logic;
            V     :  OUT std_logic ); 
    END COMPONENT; 
    Constant zero : std_logic_vector(15 downto 0) := (others => '0');
    signal sum1, sum2, sum3, sum4, sum5:  std_logic_vector(15 downto 0);
    signal CO1, CO2, CO3, CO4, CO5 : std_logic;
    signal v1, v2, v3, v4, v5 : std_logic;
    signal changedOperand : std_logic_vector(15 downto 0);
    SIGNAL var1,var2,var3 : std_logic_vector(15 downto 0);
    SIGNAL var4 : std_logic_vector( 14 downto 0);
   
begin
    var4 <= (others => '0');
    var1 <= var4 &'1'; -- = 1
    var2 <= (others => '1'); -- 111111111111111 = -1
    var3 <= (others => '0'); -- 000000000000000 
    changedOperand <= (NOT src);
    add : Adder_bits_n PORT MAP(src, dest, Cin, sum1, CO1, v1);
    U2  : Adder_bits_n PORT MAP(changedOperand, var1, Cin, sum2, CO2, v2);
    sub : Adder_bits_n PORT MAP(dest, sum2, Cin, sum3, CO3, v3);
    inc : Adder_bits_n PORT MAP(dest, var1, Cin, sum4, CO4, v4);
    dec : Adder_bits_n PORT MAP(dest, var2, Cin, sum5, CO5, v5);
    

    PROCESS (Z, operation, signal_add, signal_sub, Cin, sum1, sum3, sum4, sum5, CO1, CO3, CO4, CO5, v1, v3, v4, v5)
    BEGIN
    IF signal_add = '1'  THEN
	Z <= sum1;
        -- set carry flag
        flag_reg(0) <= CO1;
        -- set overflow result 
	flag_reg(4) <= v1;
    

     ELSIF signal_sub = '1' THEN 
	Z <= sum3;
        -- set carry flag
        flag_reg(0) <= CO3;
        -- set overflow result 
	flag_reg(4) <= v3;
       
    
    ELSE 

    IF (operation = "00000") THEN  -- Mov Operation
        Z <= src;
        -- set carry flag
	flag_reg(0) <= flag(0);
        -- reset Overflow
	flag_reg(4) <= '0';
         
    
    ELSIF (operation = "00001") THEN -- Add Operation
        Z <= sum1;
        -- set carry flag
        flag_reg(0) <= CO1;
        -- set overflow result 
	flag_reg(4) <= v1;
         

    ELSIF (operation = "00010") THEN -- ADC operation
        Z <= sum1;
        -- set carry flag
        flag_reg(0) <= CO1;
        -- set overflow result 
	flag_reg(4) <= v1;
         
    
    ELSIF (operation = "00011") THEN -- SUB operation
        Z <= sum3;
        -- set carry flag
        flag_reg(0) <= CO3;
        -- set overflow result 
	flag_reg(4) <= v3;
         

    ELSIF (operation = "00100") THEN   -- SBC operation    
        Z <= sum3;
        -- set carry flag
        flag_reg(0) <= CO3;
        -- set overflow result 
	flag_reg(4) <= v3;
         

    ELSIF (operation = "00101") THEN -- AND Operation
        Z <= (dest and src);
        flag_reg(0) <= flag(0);
        -- reset Overflow
	flag_reg(4) <= '0';
        

    ELSIF (operation = "00110")  THEN -- OR Operation
        Z <= (dest or src);
        flag_reg(0) <= flag(0);
        -- reset Overflow
	flag_reg(4) <= '0';
        
    
    ELSIF (operation = "00111") THEN -- XNOR Operation
        Z <= (dest xnor src);
        flag_reg(0) <= flag(0);
        -- reset Overflow
	flag_reg(4) <= '0';
         

    ELSIF (operation = "01000") THEN  -- cmp Operation
        Z <= dest;
	-- set carry result
	flag_reg(0) <= CO3;
        -- set Overflow result
	flag_reg(4) <= v3;
         

    ELSIF (operation = "01001") THEN -- INC Operation
        Z <= sum4;
        -- set carry flag
        flag_reg(0) <= CO4;
        -- set overflow result 
	flag_reg(4) <= v4;
        

    ELSIF (operation = "01010") THEN -- DEC Operation
        Z <= sum5;
        -- set carry flag
        flag_reg(0) <= CO5;
        -- set overflow result
	flag_reg(4) <= v5;
        

    ELSIF (operation = "01011") THEN -- CLR Operation
        Z <= (others => '0');
        -- reset C, N, V, P; set Z
        flag_reg <= "00010" ;

    ELSIF (operation = "01100") THEN -- INV Operation
        Z <= (not dest);
        -- set carry flag
        flag_reg(0) <= '1';
        -- reset overflow 
	flag_reg(4) <= '0';
        

    ELSIF (operation = "01101") THEN -- LSR Operation
        Z <= '0' & dest(15 downto 1);
	flag_reg(0) <= flag(0);
        
        flag_reg(4) <= flag(4);

    ELSIF (operation = "01110") THEN -- ROR Operation
        Z <= dest(0) & dest(15 downto 1);
	flag_reg(0) <= flag(0);

        flag_reg(4) <= flag(4);
        

    ELSIF (operation = "01111") THEN -- ROC Operation
        Z <= Cin & dest(15 downto 1); 
        -- set carry by last bit Rotated out of reg 
        flag_reg(0) <= dest(0);
        -- overflow result = N xor C 
        if signed(Z) < 0 THEN flag_reg(4) <= ( '1' xor dest(0));
        else flag_reg(4) <= ( '0' xor dest(0));
        end if;
        
        
        
    ELSIF (operation = "10000") THEN -- ASR Operation
        Z <= dest(15) & dest(15 downto 1);
	-- set carry by last bit shifted out of reg
        flag_reg(0) <= dest(0);
        -- overflow result = N xor C 
        if signed(Z) < 0 THEN flag_reg(4) <= ( '1' xor dest(0));
        else flag_reg(4) <= ( '0' xor dest(0));
        end if;
        
	
    ELSIF (operation = "10001") THEN -- LSL Operation
        Z <= dest(14 downto 0) & '0' ;
	flag_reg(0) <= flag(0);
        
        flag_reg(4) <= flag(4);
        
    ELSIF (operation = "10010") THEN -- ROL Operation 
        Z <= dest(14 downto 0) & dest(15) ;
	flag_reg(0) <= flag(0);
  
        flag_reg(4) <= flag(4);
        
    ELSIF (operation = "10011") THEN -- RLC Opertion
        Z <= dest(14 downto 0) & Cin ;
        -- set carry by last bit Rotated out of reg 
        flag_reg(0) <= dest(15);
        -- overflow result = N xor C 
        if signed(Z) < 0 THEN flag_reg(4) <= ( '1' xor dest(15));
        else flag_reg(4) <= ( '0' xor dest(15));
        end if;
       

    ELSE 
        Z <= (OTHERS => 'Z');
    END IF;
    END IF;
	IF ( operation = "01000" ) THEN -- for cmp operation
		-- check zero result
        	if sum3 = zero THEN flag_reg(1) <= '1';
        	else flag_reg(1) <= '0';
        	end if;
        	-- check negative result
        	if signed(sum3) < 0 THEN flag_reg(2) <= '1';
        	else flag_reg(2) <= '0';
        	end if;
        	-- check even result
        	if (sum3(0) = '1') then flag_reg(3) <= '0';
        	else flag_reg(3) <= '1' ;
        	end if;
	else 
		-- check zero result
        	if Z = zero THEN flag_reg(1) <= '1';
        	else flag_reg(1) <= '0';
        	end if;
        	-- check negative result
        	if signed(Z) < 0 THEN flag_reg(2) <= '1';
        	else flag_reg(2) <= '0';
        	end if;
        	-- check even result
        	if (Z(0) = '1') then flag_reg(3) <= '0';
        	else flag_reg(3) <= '1' ;
        	end if;
	
	END IF;
    END PROCESS;
end arch;
