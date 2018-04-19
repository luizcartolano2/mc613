-- brief : lab05 - question 2

library ieee;
use ieee.std_logic_1164.all;

entity cla_8bits_partial is
  port(
    x    : in  std_logic_vector(7 downto 0);
    y    : in  std_logic_vector(7 downto 0);
    cin  : in  std_logic;
    sum  : out std_logic_vector(7 downto 0);
    cout : out std_logic
  );
end cla_8bits_partial;

architecture rtl of cla_8bits_partial is
	SIGNAL c_out_less : STD_LOGIC;
	COMPONENT cla_4bits
		PORT (
			x    : in  std_logic_vector(3 downto 0);
			y    : in  std_logic_vector(3 downto 0);
			cin  : in  std_logic;
			sum  : out std_logic_vector(3 downto 0);
			cout : out std_logic
		);
	END COMPONENT;
begin
	cla_less: cla_4bits PORT MAP(x(3 DOWNTO 0), y(3 DOWNTO 0), cin, sum(3 DOWNTO 0), c_out_less);
	cla_more: cla_4bits PORT MAP(x(7 DOWNTO 4), y(7 DOWNTO 4), c_out_less, sum(7 DOWNTO 4), cout);
end rtl;
		