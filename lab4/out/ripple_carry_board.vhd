library ieee;
use ieee.std_logic_1164.all;
use work.ripple_carry;

entity ripple_carry_board is
  port (
    SW : in std_logic_vector(7 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX0 : out std_logic_vector(6 downto 0);
    LEDR : out std_logic_vector(0 downto 0)
    );
end ripple_carry_board;

architecture rtl of ripple_carry_board is
	SIGNAL c_out : STD_LOGIC;
	SIGNAL r_out : STD_LOGIC_VECTOR(0 TO 3);
	COMPONENT bin2hex
		PORT(VALOR: in std_logic_vector(3 downto 0);
           HEX_GENERIC: out std_logic_vector(6 downto 0));
	END COMPONENT;
begin
	display_x: bin2hex PORT MAP(SW(7 DOWNTO 4), HEX4);
	display_y: bin2hex PORT MAP(SW(3 DOWNTO 0), HEX2);
	instance: ripple_carry
		GENERIC MAP (N => 4)
		PORT MAP (x => SW(7 DOWNTO 4), y => SW(3 DOWNTO 0), r => r_out, cin => '0', cout => c_out, overflow => LEDR(0));
	display_r: bin2hex PORT MAP(r_out, HEX0);				
end rtl;
