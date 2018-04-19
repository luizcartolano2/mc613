library ieee;
use ieee.std_logic_1164.all;

entity barrel_shifter_board is
  port(
    SW: in  std_logic_vector (5 downto 0);
    LEDR: out std_logic_vector (3 downto 0)
  );
end barrel_shifter_board;

architecture behavioral of barrel_shifter_board is
begin
	WITH SW(5 DOWNTO 4) SELECT
	LEDR <= SW(3 DOWNTO 0) WHEN "00",
		SW(0) & SW(3) & SW(2) & SW(1) WHEN "01",
		SW(1) & SW(0) & SW(3) & SW(2) WHEN "10",
		SW(2) & SW(1) & SW(0) & SW(3) WHEN "11";
end behavioral;
