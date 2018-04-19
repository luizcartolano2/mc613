library ieee;
use ieee.std_logic_1164.all;

entity alu is
  port (
    a, b : in std_logic_vector(3 downto 0);
    F : out std_logic_vector(3 downto 0);
    s0, s1 : in std_logic;
    Z, C, V, N : out std_logic
  );
end alu;

architecture behavioral of alu is
  SIGNAL sum: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL sub: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL orr: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL annd: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL b_invert: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL operacao: STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL c_sum: STD_LOGIC;
  SIGNAL c_sub: STD_LOGIC;
  SIGNAL v_sum: STD_LOGIC;
  SIGNAL v_sub: STD_LOGIC;
  SIGNAL f_in: STD_LOGIC_VECTOR(3 DOWNTO 0);
  COMPONENT ripple_carry
   generic (
    N : integer := 4
	);
	port (
		x,y : in std_logic_vector(N-1 downto 0);
		r : out std_logic_vector(N-1 downto 0);
		cin : in std_logic;
		cout : out std_logic;
		overflow : out std_logic
	);
  END COMPONENT;
begin
  --soma
	instance: ripple_carry
		GENERIC MAP (N => 4)
		PORT MAP(x => a , y => b, r => sum, cin => '0', cout => c_sum, overflow => v_sum);
	
	--subtrai
	b_invert(0) <= b(0) xor '1';
	b_invert(1) <= b(1) xor '1';
	b_invert(2) <= b(2) xor '1';
	b_invert(3) <= b(3) xor '1';
	
	instance2: ripple_carry
		GENERIC MAP (N => 4)
		PORT MAP(x => a, y => b_invert, r => sub, cin => '1', cout => c_sub, overflow => v_sub);
	
	--or
	orr(0) <= a(0) or b(0);
	orr(1) <= a(1) or b(1);
	orr(2) <= a(2) or b(2);
	orr(3) <= a(3) or b(3);
	
	--and
	annd(0) <= a(0) and b(0);
	annd(1) <= a(1) and b(1);
	annd(2) <= a(2) and b(2);
	annd(3) <= a(3) and b(3);
	
	operacao <= s1 & s0;
	
	WITH operacao SELECT
		f_in 	<= sum WHEN "00",
			 sub WHEN "01",
			 annd WHEN "10",
			 orr WHEN "11";
			
	WITH f_in SELECT
		Z 	<= '1' WHEN "0000",
			 '0' WHEN OTHERS;
	
	WITH operacao SELECT
		N 	<= '0' WHEN "10",
			 '0' WHEN "11",
			 f_in(3) WHEN OTHERS;
	
	WITH operacao SELECT
		C	<= c_sum WHEN "00",
			 '0' WHEN OTHERS;
	
	WITH operacao SELECT
		V	<= v_sum WHEN "00",
			 v_sub WHEN "01",
			 '0' WHEN OTHERS;
			 
	F <= f_in;
	
 end behavioral;
