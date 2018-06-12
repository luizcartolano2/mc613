LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity mouse is
	port
	(
		clock 			: in std_logic;
		ps2_data 		: inout STD_LOGIC;
		ps2_clock		: inout STD_LOGIC;
		resetn			: in std_logic;
		position_x 		: out std_logic_vector(7 downto 0);
		position_y 		: out std_logic_vector(7 downto 0);
		comandos_mouse : out std_logic_vector(3 downto 0);
		estado_mouse 	: in std_logic_vector(1 downto 0);
		grid_jogo		: in std_logic_vector(17 downto 0)
	);
end;

architecture struct of mouse is
	component atualiza_posicao
		port(
			clock_50mhz	: in STD_LOGIC;
			ps2_data 	: inout STD_LOGIC;
			ps2_clock	: inout STD_LOGIC;
			resetn		: in std_logic;
			position_x 	: out std_logic_vector(7 downto 0);
			position_y 	: out std_logic_vector(7 downto 0)
		);
	end component;
	component valida_clique
		port(
			clock_50mhz		: in STD_LOGIC;
			ps2_data 		: inout STD_LOGIC;
			ps2_clock		: inout STD_LOGIC;
			resetn			: in std_logic;
			position_x 		: in std_logic_vector(7 downto 0);
			position_y 		: in std_logic_vector(7 downto 0);
			comando 			: out std_logic_vector(3 downto 0);
			estado_mouse 	: in std_logic_vector(1 downto 0);
			grid_jogo		: in std_logic_vector(17 downto 0)
		);
	end component;
	signal local_x, local_y : std_logic_vector(7 downto 0);
begin 	
	recebe_posicao : atualiza_posicao port map (clock, ps2_data, ps2_clock, resetn, local_x, local_y);
	acoes_clique : valida_clique port map (clock, ps2_data, ps2_clock, resetn, local_x, local_y, comandos_mouse, estado_mouse, grid_jogo);
	position_x <= local_x;
	position_y <= local_y;
	

end struct;
