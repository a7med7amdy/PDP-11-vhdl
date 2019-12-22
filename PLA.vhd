library ieee;
use ieee.std_logic_1164.all;

ENTITY PLA IS
	PORT (
	IR : IN  std_logic_vector (15 Downto 0);
	M0 : IN  std_logic_vector (2 Downto 0);
	BR,HLT,OneOP,OneORTwoOP, RegisterDirect : OUT std_logic;
	Address,operation : OUT std_logic_vector(4 Downto 0));
END ENTITY PLA;

ARCHITECTURE struct OF PLA IS

signal OP1,OP2, Jmp, RTS, ZeroOP,RegDirect, op1or2 : std_logic;
signal mov,add,adc,sub,sbc,andd,orr,xnorr,cmp,inc,dec,clr,inv,lsr,rorr,rrc,asr,lsl,roll,rlc : std_logic ;

begin
	OP2       <= not(IR(15)) or ( IR(15) and not(IR(14)) and not(IR(13)) and not(IR(12)) );
	OP1       <= IR(15) and not(IR(14)) and IR(13);
	op1or2    <= OP1 or OP2;
	BR        <= IR(15) and IR(14) and not(IR(13) and IR(12) and IR(11)) ;
	ZeroOP    <= IR(15) and IR(14) and IR(13) and IR(12) and IR(11) ;
	RegDirect <= not (M0(2) or M0(1) or M0(0)) and op1or2;
	HLT       <= ZeroOP and not(IR(10)) and not(IR(9)) and not(IR(8));
	Jmp       <= ZeroOP and not(IR(10)) and IR(9) and not(IR(8));
	RTS       <= ZeroOP and not(IR(10)) and IR(9) and IR(8);

	Address(0) <= RTS;
	Address(1) <= RegDirect;
	Address(2) <= op1or2 or RTS;
	Address(3) <= Jmp or RTS;
	Address(4) <= RegDirect or jmp or RTS;
	
	RegisterDirect<=RegDirect;
	OneOP      <= OP1;
	OneORTwoOP <= op1or2;

	mov<=not (IR(15)) and not(IR(14)) and not (IR(13)) and not (IR(12));
	add<=OP2 and not(IR(14)) and not (IR(13)) and IR(12);
	adc<=OP2 and not(IR(14)) and IR(13) and not (IR(12));
	sub<=OP2 and not(IR(14)) and IR(13) and IR(12);
	sbc<=OP2 and IR(14) and not (IR(13)) and  not (IR(12));
	andd<=OP2 and IR(14) and not (IR(13)) and IR(12);
	orr<=OP2 and IR(14) and IR(13) and not (IR(12));
	xnorr<=OP2 and IR(14) and IR(13) and IR(12);
	cmp<=IR(15) and not(IR(14)) and not (IR(13)) and not (IR(12));

	inc<=OP1 and not (IR(12)) and not (IR(11)) and not (IR(10)) and not (IR(9));
	dec<=OP1 and not (IR(12)) and not (IR(11)) and not (IR(10)) and IR(9);
	clr<=OP1 and not (IR(12)) and not (IR(11)) and IR(10) and not (IR(9));
	inv<=OP1 and not (IR(12)) and not (IR(11)) and IR(10) and IR(9);
	lsr<=OP1 and not (IR(12)) and IR(11) and not (IR(10)) and not (IR(9));
	rorr<=OP1 and not (IR(12)) and IR(11) and not (IR(10)) and IR(9);
	rrc<=OP1 and not (IR(12)) and IR(11) and IR(10) and not (IR(9));
	asr<=OP1 and not (IR(12)) and IR(11) and IR(10) and IR(9);
	lsl<=OP1 and IR(12) and not (IR(11)) and not (IR(10)) and not (IR(9));
	roll<=OP1 and IR(12) and not (IR(11)) and not (IR(10)) and IR(9);
	rlc<=OP1 and IR(12) and not (IR(11)) and IR(10) and not (IR(9));

	operation(0)<=add or sub or andd or xnorr or inc or clr or lsr or rrc or lsl or rlc;
	operation(1)<=adc or sub or orr or xnorr or dec or clr or rorr or rrc or roll or rlc;
	operation(2)<=sbc or andd or orr or xnorr or inv or lsr or rorr or rrc;
	operation(3)<=cmp or inc or dec or clr or inv or lsr or rorr or rrc;
	operation(4)<=asr or lsl or roll or rlc;
	
end struct;

---------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY LoadFromPLA IS
	PORT (
	IR : IN std_logic_vector (15 Downto 0);
	M0 : IN std_logic_vector (2 Downto 0);
	S_bit:  IN std_logic ;
	BR,HLT,OneOP : OUT std_logic;
	Address,operation : OUT std_logic_vector(4 Downto 0));
END ENTITY LoadFromPLA;

Architecture struct2 of  LoadFromPLA is

signal OneORTwoOP,RegisterDirect : std_logic;
signal P : std_logic_vector(4 downto 0);
signal MUXout,Mux0,p1Sbit: std_logic_vector(1 downto 0);


begin
	Mux0 <= M0(1 downto 0);
	p1Sbit <= P(1)&S_bit;
	L0: entity work.PLA port map (IR,M0,BR,HLT,OneOP,OneORTwoOP,RegisterDirect,P,operation);
	L1: entity work.mux4_2bit port map (P(1 downto 0),P(1 downto 0),Mux0,p1Sbit,OneORTwoOP,RegisterDirect,MUXout);

	Address <= P(4 downto 2) & (P(1) or MUXout(1)) & (P(0) or MUXout(0));

end struct2;



