library ieee;
use ieee.std_logic_1164.all;

entity alu_board is
  port (
    SW : in std_logic_vector(9 downto 0);
    HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0);
    LEDR : out std_logic_vector(3 downto 0)
  );
end alu_board;

architecture behavioral of alu_board is
  SIGNAL result: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL negativo_a: STD_LOGIC;
  SIGNAL negativo_b: STD_LOGIC;
  SIGNAL negativo_f: STD_LOGIC;
  SIGNAL hex5_dec: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex4_dec: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex3_dec: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex2_dec: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex1_dec: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex0_dec: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex5_hex: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex4_hex: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex3_hex: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex2_hex: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex1_hex: STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL hex0_hex: STD_LOGIC_VECTOR(6 DOWNTO 0);
  COMPONENT alu
    PORT (
      a, b : in std_logic_vector(3 downto 0);
      F : out std_logic_vector(3 downto 0);
      s0, s1 : in std_logic;
      Z, C, V, N : out std_logic
    );
  END COMPONENT;
  COMPONENT bin2hex
    PORT (
      VALOR: in std_logic_vector(3 downto 0);
      HEX_GENERIC: out std_logic_vector(6 downto 0)
    );
  END COMPONENT;
  COMPONENT two_comp_to_7seg
    PORT (
      bin : in std_logic_vector(3 downto 0);
      segs : out std_logic_vector(6 downto 0);
      neg : out std_logic
    );
	END COMPONENT;
begin    
	hex5_hex <= "1111111";
	hex3_hex <= "1111111";
	hex1_hex <= "1111111";
    ula: alu PORT MAP
      (SW(7 DOWNTO 4), SW(3 DOWNTO 0), result, SW(9), SW(8), LEDR(3), LEDR(2), LEDR(1), LEDR(0));
	
		a_dec: two_comp_to_7seg PORT MAP
        (SW(7 DOWNTO 4), hex4_dec, negativo_a); 
		with negativo_a select
		hex5_dec <= "0111111" when '1',
						"1111111" when '0';
		
		 a_hex: bin2hex PORT MAP
        (SW(7 DOWNTO 4), hex4_hex);
		  
		 b_dec: two_comp_to_7seg PORT MAP
        (SW(3 DOWNTO 0), hex2_dec, negativo_b); 	  
		with negativo_b select
		hex3_dec <= "0111111" when '1',
						"1111111" when '0';
		
		 b_hex: bin2hex PORT MAP
        (SW(3 DOWNTO 0), hex2_hex);
		 
		 f_dec: two_comp_to_7seg PORT MAP
        (result, hex0_dec, negativo_f); 	  
		with negativo_f select
		hex1_dec <= "0111111" when '1',
						"1111111" when '0';
		
		 f_hex: bin2hex PORT MAP
        (result, hex0_hex);
		
		WITH SW(8) SELECT
			HEX4 <= hex4_dec WHEN '0',
						hex4_hex WHEN '1';
		
		WITH SW(8) SELECT
			HEX5 <= hex5_dec WHEN '0',
						hex5_hex WHEN '1';
						
		WITH SW(8) SELECT
			HEX3 <= hex3_dec WHEN '0',
						hex3_hex WHEN '1';
		
		WITH SW(8) SELECT
			HEX2 <= hex2_dec WHEN '0',
						hex2_hex WHEN '1';
		
		WITH SW(8) SELECT
			HEX1 <= hex1_dec WHEN '0',
						hex1_hex WHEN '1';
		
		WITH SW(8) SELECT
			HEX0 <= hex0_dec WHEN '0',
						hex0_hex WHEN '1';
end behavioral;
