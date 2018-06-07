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
		HEX0 : out std_logic_vector(6 downto 0);
		HEX1 : out std_logic_vector(6 downto 0);
		HEX2 : out std_logic_vector(6 downto 0);
		HEX3 : out std_logic_vector(6 downto 0)
		-- END RETIRAR
	);
end;

architecture struct of velha is
	component mouse
		port(
			clock_50mhz	: 	in	STD_LOGIC;
			ps2_data 	:	inout	STD_LOGIC;
			ps2_clock	:	inout	STD_LOGIC;
			resetn	: in std_logic;
			position_x 	: 	out std_logic_vector(7 downto 0);
			position_y 	: 	out std_logic_vector(7 downto 0)
		);
	end component;
	component monitor
		port(
			clock_50mhz					: in	STD_LOGIC;
			mouse_position_x			: in 	std_logic_vector(7 downto 0);
			mouse_position_y			: in 	std_logic_vector(7 downto 0);
			rstn							: in	std_logic;
			vga_r, vga_g, vga_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			vga_hs, vga_vs				: OUT STD_LOGIC;
			vga_blank_n, vga_sync_n : OUT STD_LOGIC;
			vga_clk 						: OUT STD_LOGIC
		);
	end component;
	component uc
		port(
			clock					: in	std_logic;
			resetn					: in	std_logic;
			comando_entrada 	: in 	std_logic_vector(2 downto 0);
			comando_mouse		: out std_logic_vector(2 downto 0);
			comando_monitor	: out std_logic_vector(2 downto 0)
		);
	end component;
	-- RETIRAR
	component bin2hex
		port (
            SW: in std_logic_vector(3 downto 0);
            HEX0: out std_logic_vector(6 downto 0)
      );
	end component;
	-- END RETIRAR
	
	signal mouse_x : std_logic_vector(7 downto 0);
	signal mouse_y : std_logic_vector(7 downto 0);
	signal entrada : std_logic_vector(2 downto 0);
	signal saida_mouse : std_logic_vector(2 downto 0);
	signal saida_monitor : std_logic_vector(2 downto 0);
begin 
	controle : uc port map(CLOCK_50, KEY(0), entrada, saida_mouse, saida_monitor);
	mouse_position : mouse port map(CLOCK_50, PS2_DAT, PS2_CLK, KEY(0), mouse_x, mouse_y);
	mouse_monitor : monitor port map(CLOCK_50, mouse_x, mouse_y, KEY(0), VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK);
	
	-- RETIRAR
	display1 : bin2hex port map(mouse_x(3 downto 0), HEX0);
	display2 : bin2hex port map(mouse_x(7 downto 4), HEX1);
	display3 : bin2hex port map(mouse_y(3 downto 0), HEX2);
	display4 : bin2hex port map(mouse_y(7 downto 4), HEX3);
	-- END RETIRAR
end struct;
