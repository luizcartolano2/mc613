library ieee;
use ieee.std_logic_1164.all;

entity xbar_gen is
  GENERIC(N: INTEGER:=1);
  port(s: in std_logic_vector (N-1 downto 0);
       y1, y2: out std_logic);
end xbar_gen;

architecture rtl of xbar_gen is
	SIGNAL f1: STD_LOGIC_VECTOR(0 TO N);
	SIGNAL f2: STD_LOGIC_VECTOR(0 TO N);
	COMPONENT xbar_v3
		port(x1, x2, s: in std_logic;
       		y1, y2: out std_logic);
	END COMPONENT;
begin
  -- add your code
	f1(0) <= '1';
	f2(0) <= '0';
	
	CROSSBARN: 
	FOR i IN 0 TO N-1 GENERATE
		xbar: xbar_v3 PORT MAP(f1(i), f2(i), s(i), f1(i+1), f2(i+1));
	END GENERATE;
	
	y1 <= f1(N);
	y2 <= f2(N);
end rtl;
