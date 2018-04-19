-- brief : lab05 - question 2

library ieee;
use ieee.std_logic_1164.all;

entity cla_4bits is
  port(
    x    : in  std_logic_vector(3 downto 0);
    y    : in  std_logic_vector(3 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(3 downto 0);
    cout : out std_logic
  );
end cla_4bits;

architecture rtl of cla_4bits is
	SIGNAL p : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL g : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL trash : STD_LOGIC;
	COMPONENT full_adder 
		PORT ( 
			x, y : in std_logic;
			r : out std_logic;
			cin : in std_logic;
			cout : out std_logic
		);
	END COMPONENT;
begin
	in_set: FOR i IN 0 TO 3 GENERATE
		p(i) <= x(i) OR y(i);
		g(i) <= x(i) AND y(i);
	END GENERATE;

	c(0) <= cin;
	c(1) <= g(0) OR (p(0) AND c(0));
	c(2) <= g(1) OR (p(1) AND g(0)) OR (p(1) AND p(0) AND c(0));
	c(3) <= g(2) OR (p(2) AND g(1)) OR (p(2) AND p(1) AND g(0)) OR (p(2) AND p(1) AND p(0) AND c(0));
	cout <= g(3) OR (p(3) AND g(2)) OR (p(3) AND p(2) AND g(1)) OR (p(3) AND p(2) AND p(1) AND g(0)) OR (p(3) AND p(2) AND p(1) AND p(0) AND c(0));

	out_set: FOR i IN 0 TO 3 GENERATE
		cla : full_adder PORT MAP (x(i), y(i), sum(i), c(i), trash);
	END GENERATE;
end rtl;
