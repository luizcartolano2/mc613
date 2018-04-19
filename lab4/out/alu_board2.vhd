library ieee;
use ieee.std_logic_1164.all;

entity alu_board2 is
  port (
    SW : in std_logic_vector(9 downto 0);
    HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0);
    LEDR : out std_logic_vector(3 downto 0)
  );
end alu_board2;

architecture behavioral of alu_board2 is
  SIGNAL result: STD_LOGIC_VECTOR(3 DOWNTO 0);
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
  PROCESS (SW)
  VARIABLE negativo : STD_LOGIC;
  BEGIN 
    ula: alu PORT MAP
      (SW(7 DOWNTO 4), SW(3 DOWNTO 0), result, SW(9), SW(8), LEDR(3), LEDR(2), LEDR(1), LEDR(0));
      
    IF SW(8) = '0' THEN 
      op_a: two_comp_to_7seg PORT MAP
        (SW(7 DOWNTO 4), HEX4, negativo);
      HEX5(6) <= negativo XOR 1;
      op_b: two_comp_to_7seg PORT MAP
        (SW(3 DOWNTO 0), HEX2, negativo);
      HEX3(6) <= negativo XOR 1;
      op_f: two_comp_to_7seg PORT MAP
        (result, HEX0, negativo);
      HEX1(6) <= negativo XOR 1;
    ELSE
      op_a_hex: bin2hex PORT MAP
        (SW(7 DOWNTO 4), HEX4);
      op_b_hex: bin2hex PORT MAP
        (SW(3 DOWNTO 0), HEX2);
      op_f_gex: bin2hex PORT MAP
        (result, HEX0);
    END IF;
  END PROCESS;
end behavioral;