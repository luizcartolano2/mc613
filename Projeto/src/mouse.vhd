LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity mouse is
	port
	(
		clock : in std_logic;
		ps2_data 	:	inout	STD_LOGIC;
		ps2_clock	:	inout	STD_LOGIC;
		resetn	: in std_logic;
		entrada_mouse : in std_logic_vector(2 downto 0)
		
	);
end;

architecture struct of mouse is
	component atualiza_posicao
		port(
			clock_50mhz	: 	in	STD_LOGIC;
			ps2_data 	:	inout	STD_LOGIC;
			ps2_clock	:	inout	STD_LOGIC;
			resetn	: in std_logic;
			position_x 	: 	out std_logic_vector(7 downto 0);
			position_y 	: 	out std_logic_vector(7 downto 0)
		);
	end component;
begin 	

end struct;
