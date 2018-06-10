LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity velha is
	port
	(
		------------------------	Clock Input	 	------------------------
		CLOCK_50	:	in std_logic;		--	50 MHz
		
		------------------------	PS2		--------------------------------
		PS2_DAT	:	inout	STD_LOGIC;	--	PS2 Data
		PS2_CLK	:	inout	STD_LOGIC;	--	PS2 Clock
		
		------------------------	VGA		--------------------------------
		VGA_R, VGA_G, VGA_B	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		VGA_HS, VGA_VS		: OUT STD_LOGIC;
		VGA_BLANK_N, VGA_SYNC_N : OUT STD_LOGIC;
		VGA_CLK : OUT STD_LOGIC;
		
		------------------------	Push Button		------------------------
		KEY 	:		in	STD_LOGIC_VECTOR (3 downto 0);		--	Pushbutton[3:0]
		
		-- RETIRAR
		------------------------	Displays	------------------------
		HEX0 : out std_logic_vector(6 downto 0);
		HEX1 : out std_logic_vector(6 downto 0);
		HEX2 : out std_logic_vector(6 downto 0);
		HEX3 : out std_logic_vector(6 downto 0);
		HEX4 : out std_logic_vector(6 downto 0);
		HEX5 : out std_logic_vector(6 downto 0)
		-- RETIRAR
	);
end;

architecture struct of velha is
	component mouse
		port(
			clock 			: in std_logic;
			ps2_data 		: inout STD_LOGIC;
			ps2_clock		: inout STD_LOGIC;
			resetn			: in std_logic;
			position_x 		: out std_logic_vector(7 downto 0);
			position_y 		: out std_logic_vector(7 downto 0);
			comandos_mouse : out std_logic_vector(3 downto 0);
			estado_mouse	: in std_logic_vector(1 downto 0);
			grid_jogo		: in std_logic_vector(17 downto 0)
		);
	end component;
	component monitor
		port(
			clock_50mhz					: in	STD_LOGIC;
			mouse_position_x			: in 	std_logic_vector(7 downto 0);
			mouse_position_y			: in 	std_logic_vector(7 downto 0);
			rstn							: in 	std_logic;
			vga_r, vga_g, vga_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			vga_hs, vga_vs				: OUT STD_LOGIC;
			vga_blank_n, vga_sync_n : OUT STD_LOGIC;
			vga_clk 						: OUT STD_LOGIC;
			entrada_monitor			: in std_logic_vector(1 downto 0);
			grid_jogo					: in std_logic_vector(17 downto 0);
			modo_jogo					: in std_logic;
			first_player				: in std_logic;
			vencedor						: in std_logic_vector(1 downto 0)
		);
	end component;
	component uc
		port(
			clock					: in	std_logic;
			resetn				: in	std_logic;
			comando_entrada 	: in 	std_logic_vector(3 downto 0);
			comando_monitor	: out std_logic_vector(1 downto 0);
			mouse_validos 		: out std_logic_vector(1 downto 0);
			grid_jogo			: out std_logic_vector(17 downto 0);
			modo_jogo 			: out std_logic;
			first_player 		: out std_logic;
			vencedor				: out std_logic_vector(1 downto 0);
			ia_ativo				: out std_logic;
			ia_posicao			: in integer range 0 to 9;
			ia_cor				: out std_logic_vector(1 downto 0)
		);
	end component;	
	component ia
		port(
			ativo			: in std_logic;
			gride_jogo	: in std_logic_vector(17 DOWNTO 0); 
			posicao		: out integer range 0 to 9;
			ia_cor		: in std_logic_vector(1 downto 0)
	);
	end component;
	-- RETIRAR
	component bin2hex
		port (
            entrada: in std_logic_vector(3 downto 0);
            saida: out std_logic_vector(6 downto 0)
      );
	end component;
	-- RETIRAR
	
	signal mouse_x : std_logic_vector(7 downto 0);
	signal mouse_y : std_logic_vector(7 downto 0);
	signal entrada : std_logic_vector(3 downto 0);
	signal saida_mouse : std_logic_vector(4 downto 0);
	signal saida_monitor : std_logic_vector(1 downto 0);
	
	signal print_f : std_logic_vector(3 downto 0);
	signal print_p : std_logic_vector(3 downto 0);
	signal print_g : std_logic_vector(3 downto 0);
	signal print_e : std_logic_vector(3 downto 0);
	signal print_w : std_logic_vector(3 downto 0);
	signal print_q : std_logic_vector(3 downto 0);
	signal estado_mouse : std_logic_vector(1 downto 0);
	
	signal grid_jogo : std_logic_vector(17 downto 0);
	signal modo_jogo : std_logic;
	signal first_player : std_logic;
	signal vencedor : std_logic_vector(1 downto 0);
	
	signal ia_ativo : std_logic;
	signal ia_posicao : integer range 0 to 9;
	signal ia_cor : std_logic_vector(1 downto 0);
begin 
	controle : uc port map(CLOCK_50, KEY(0), entrada, saida_monitor, estado_mouse, grid_jogo, modo_jogo, first_player, vencedor, ia_ativo, ia_posicao, ia_cor);
	mouse_position : mouse port map(CLOCK_50, PS2_DAT, PS2_CLK, KEY(0), mouse_x, mouse_y, entrada, estado_mouse, grid_jogo);
	mouse_monitor : monitor port map(CLOCK_50, mouse_x, mouse_y, KEY(0), VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK, saida_monitor, grid_jogo, modo_jogo, first_player, vencedor);
	inteligencia : ia port map(ia_ativo, grid_jogo, ia_posicao, ia_cor);
	
	-- RETIRAR
	--print_f <= "00" & saida_ram(3 downto 2);
	--print_f <= ram_linha1(3 downto 0);
	--print_f <= ram_linha1(3 downto 0);
	print_f <= grid_jogo(15 downto 12);
	
	--print_p <= "00" & ram_linha1(5 downto 4);
	print_p <= "00" & grid_jogo(17 downto 16);
	--print_p <= "00" & ram_linha1(5 downto 4);
	
	--print_g <= "00" & saida_ram(1 downto 0);
	--print_g <= "00" & endereco_ram;
	---print_g <= "000" & modo_jogo;
	with ia_posicao select
		print_g <= "0001" when 1,
						"0010" when 2,
						"0011" when 3,
						"0100" when 4,
						"0101" when 5,
						"0110" when 6,
						"0111" when 7,
						"1000" when 8,
						"1001" when 9,
						"0000" when others;
	--print_g <= "00" & vencedor;
	--print_g <= entrada;
	--print_g <= "00" & ram_linha2(5 downto 4);
	
	--print_e <= "00" & endereco_ram;
	--print_e <= "000" & gravar;
	print_e <= "000" & first_player;
	--print_e <= ram_linha2(3 downto 0);
	
	--print_w <= "000" & gravar;
	--print_w <= "00" & dado_ram(5 downto 4);
	--print_w <= "00" & ram_linha3(5 downto 4);
	--print_w <= "00" & grid_jogo(11 downto 10);
	print_w <= entrada;
	
	--print_q <= mouse_x(3 downto 0);
	--print_q <= dado_ram(3 downto 0);
	--print_q <= ram_linha3(3 downto 0);
	--print_q <= grid_jogo(9 downto 6);
	print_q <= "000" & ia_ativo;
	
	display1 : bin2hex port map(print_q, HEX0);
	display2 : bin2hex port map(print_w, HEX1);
	display3 : bin2hex port map(print_e, HEX2);
	display4 : bin2hex port map(print_g, HEX3);
	display5 : bin2hex port map(print_f, HEX4);
	display6 : bin2hex port map(print_p, HEX5);
	-- END RETIRAR
end struct;
