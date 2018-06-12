LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity monitor is
	port
	(
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
end;

architecture struct of monitor is	
	COMPONENT vgacon IS
		GENERIC (
			NUM_HORZ_PIXELS : NATURAL := 128;	-- Number of horizontal pixels
			NUM_VERT_PIXELS : NATURAL := 96		-- Number of vertical pixels
		);
		PORT (
			clk50M, rstn              : IN STD_LOGIC;
			write_clk, write_enable   : IN STD_LOGIC;
			write_addr                : IN INTEGER RANGE 0 TO NUM_HORZ_PIXELS * NUM_VERT_PIXELS - 1;
			data_in                   : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			vga_clk                   : buffer std_logic;
			red, green, blue          : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			hsync, vsync              : OUT STD_LOGIC;
			sync, blank					  : OUT STD_LOGIC
		);
	END COMPONENT;
	
	CONSTANT CONS_CLOCK_DIV : INTEGER := 1000000;
	CONSTANT HORZ_SIZE : INTEGER := 128;
	CONSTANT VERT_SIZE : INTEGER := 96;
	
	SIGNAL slow_clock : STD_LOGIC;
	
	SIGNAL clear_video_address	,
		normal_video_address	,
		video_address			: INTEGER RANGE 0 TO HORZ_SIZE * VERT_SIZE - 1;
	
	SIGNAL clear_video_word		,
		normal_video_word		,
		video_word				: STD_LOGIC_VECTOR (2 DOWNTO 0);
	
	TYPE VGA_STATES IS (NORMAL, CLEAR);
	SIGNAL state : VGA_STATES;
	
	signal switch, clk50M, sync, blank : std_logic;
	signal gravar_monitor : std_logic;
	
	signal mouse_x_tmp : integer range 0 to HORZ_SIZE - 1;
	signal mouse_y_tmp : integer range 0 to VERT_SIZE - 1;
begin 
	clk50M <= clock_50mhz;
	vga_component: vgacon
	GENERIC MAP (
		NUM_HORZ_PIXELS => HORZ_SIZE,
		NUM_VERT_PIXELS => VERT_SIZE
	) PORT MAP (
		clk50M			=> clk50M		,
		rstn			=> rstn		,
		write_clk		=> clk50M		,
		write_enable	=> gravar_monitor			,
		write_addr      => video_address,
		vga_clk		=> vga_clk,
		data_in         => video_word	,
		red				=> vga_r		,
		green			=> vga_g		,
		blue			=> vga_b		,
		hsync			=> vga_hs		,
		vsync			=> vga_vs		,
		sync			=> sync		,
		blank			=> blank
	);
	vga_sync_n <= NOT sync;
	vga_blank_n <= NOT blank;
	
	with mouse_position_x select
		mouse_x_tmp <= 127 when "00111111",
							126 when "00111110",
							125 when "00111101",
							124 when "00111100",
							123 when "00111011",
							122 when "00111010",
							121 when "00111001",
							120 when "00111000",
							119 when "00110111",
							118 when "00110110",
							117 when "00110101",
							116 when "00110100",
							115 when "00110011",
							114 when "00110010",
							113 when "00110001",
							112 when "00110000",
							111 when "00101111",
							110 when "00101110",
							109 when "00101101",
							108 when "00101100",
							107 when "00101011",
							106 when "00101010",
							105 when "00101001",
							104 when "00101000",
							103 when "00100111",
							102 when "00100110",
							101 when "00100101",
							100 when "00100100",
							99 when "00100011",
							98 when "00100010",
							97 when "00100001",
							96 when "00100000",
							95 when "00011111",
							94 when "00011110",
							93 when "00011101",
							92 when "00011100",
							91 when "00011011",
							90 when "00011010",
							89 when "00011001",
							88 when "00011000",
							87 when "00010111",
							86 when "00010110",
							85 when "00010101",
							84 when "00010100",
							83 when "00010011",
							82 when "00010010",
							81 when "00010001",
							80 when "00010000",
							79 when "00001111",
							78 when "00001110",
							77 when "00001101",
							76 when "00001100",
							75 when "00001011",
							74 when "00001010",
							73 when "00001001",
							72 when "00001000",
							71 when "00000111",
							70 when "00000110",
							69 when "00000101",
							68 when "00000100",
							67 when "00000011",
							66 when "00000010",
							65 when "00000001",
							64 when "00000000", 
							63 when "11111111",
							62 when "11111110",
							61 when "11111101",
							60 when "11111100",
							59 when "11111011",
							58 when "11111010",
							57 when "11111001",
							56 when "11111000",
							55 when "11110111",
							54 when "11110110",
							53 when "11110101",
							52 when "11110100",
							51 when "11110011",
							50 when "11110010",
							49 when "11110001",
							48 when "11110000",
							47 when "11101111", 
							46 when "11101110",
							45 when "11101101",
							44 when "11101100",
							43 when "11101011",
							42 when "11101010",
							41 when "11101001",
							40 when "11101000",
							39 when "11100111",
							38 when "11100110",
							37 when "11100101",
							36 when "11100100",
							35 when "11100011",
							34 when "11100010",
							33 when "11100001",
							32 when "11100000",
							31 when "11011111",
							30 when "11011110",
							29 when "11011101",
							28 when "11011100",
							27 when "11011011",
							26 when "11011010",
							25 when "11011001",
							24 when "11011000",
							23 when "11010111",
							22 when "11010110",
							21 when "11010101",
							20 when "11010100",
							19 when "11010011",
							18 when "11010010",
							17 when "11010001",
							16 when "11010000",
							15 when "11001111",
							14 when "11001110",
							13 when "11001101",
							12 when "11001100",
							11 when "11001011",
							10 when "11001010",
							9 when "11001001",
							8 when "11001000",
							7 when "11000111",
							6 when "11000110",
							5 when "11000101",
							4 when "11000100",
							3 when "11000011",
							2 when "11000010",
							1 when "11000001",
							0 when "11000000", 
							mouse_x_tmp when others;
							
	with mouse_position_y select
		mouse_y_tmp <= 95 when "11010001",
							94 when "11010010",
							93 when "11010011",
							92 when "11010100",
							91 when "11010101",
							90 when "11010110",
							89 when "11010111",
							88 when "11011000",
							87 when "11011001",
							86 when "11011010",
							85 when "11011011",
							84 when "11011100",
							83 when "11011101",
							82 when "11011110",
							81 when "11011111",
							80 when "11100000",
							79 when "11100001",
							78 when "11100010",
							77 when "11100011",
							76 when "11100100",
							75 when "11100101",
							74 when "11100110",
							73 when "11100111",
							72 when "11101000",
							71 when "11101001",
							70 when "11101010",
							69 when "11101011",
							68 when "11101100",
							67 when "11101101",
							66 when "11101110",
							65 when "11101111",
							64 when "11110000",
							63 when "11110001",
							62 when "11110010",
							61 when "11110011",
							60 when "11110100",
							59 when "11110101",
							58 when "11110110",
							57 when "11110111",
							56 when "11111000",
							55 when "11111001",
							54 when "11111010",
							53 when "11111011",
							52 when "11111100",
							51 when "11111101",
							50 when "11111110",
							49 when "11111111",
							48 when "00000000",
							47 when "00000001",
							46 when "00000010",
							45 when "00000011",
							44 when "00000100",
							43 when "00000101",
							42 when "00000110",
							41 when "00000111",
							40 when "00001000",
							39 when "00001001",
							38 when "00001010",
							37 when "00001011",
							36 when "00001100",
							35 when "00001101",
							34 when "00001110",
							33 when "00001111",
							32 when "00010000",
							31 when "00010001",
							30 when "00010010",
							29 when "00010011",
							28 when "00010100",
							27 when "00010101",
							26 when "00010110",
							25 when "00010111",
							24 when "00011000",
							23 when "00011001",
							22 when "00011010",
							21 when "00011011",
							20 when "00011100",
							19 when "00011101",
							18 when "00011110",
							17 when "00011111",
							16 when "00100000",
							15 when "00100001",
							14 when "00100010",
							13 when "00100011",
							12 when "00100100",
							11 when "00100101",
							10 when "00100110",
							9 when "00100111",
							8 when "00101000",
							7 when "00101001",
							6 when "00101010",
							5 when "00101011",
							4 when "00101100",
							3 when "00101101",
							2 when "00101110", 
							1 when "00101111", 
							0 when "00110000", 
							mouse_y_tmp when others;
							
	process(clock_50mhz)
		variable video_address_tmp : integer RANGE 0 TO HORZ_SIZE * VERT_SIZE - 1;
		variable mouse_position : integer range 0 to HORZ_SIZE * VERT_SIZE - 1;
		variable tela : std_logic_vector(0 to ((HORZ_SIZE * VERT_SIZE * 2) - 1));
		variable bit_tela : std_logic;
		variable x_base : integer;
		variable y_base : integer;
		variable x_ocupado : integer;
		variable y_ocupado : integer;
	begin
		if clock_50mhz'event and clock_50mhz = '1' then		
			gravar_monitor <= '0';
			case entrada_monitor is
				when "00" =>
					bit_tela := '0';
					tela := (others => bit_tela);
					--tela(8*2) := '1';
					--tela((8*2)+1) := '1';
					
					x_ocupado := 0;
					y_ocupado := 0;
					
					-- MODO
					y_base := 12;
					
					-- M
					x_base := 51;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+4)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+5)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+5)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+10)*2)  := '1';
					tela((((HORZ_SIZE*y_base)+x_base+10)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+9)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+9)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+8)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+8)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+7)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+7)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+6)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+6)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+11)*2)+1) := '1';
					
					x_ocupado := 12;
					
					-- O
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- D
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- O
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '1';
					
					y_ocupado := 5;
					
					-- PvP	PvIA
					y_base := y_base + y_ocupado + 8;
					
					-- Quadrado
					x_base := 30;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+3)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+3)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+4)*2)+1) := '1';
					
					x_ocupado := 5;
					
					-- P
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- v
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- P
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- Quadrado
					x_base := x_base + x_ocupado + 26;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+3)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+3)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+4)*2)+1) := '1';
					
					x_ocupado := 5;
					
					-- P
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- v
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- I
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- A
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					y_ocupado := 5;
					-- Primeiro jogador
					y_base := y_base + y_ocupado + 16;
					
					-- C
					x_base := 33;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- O
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- R
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- D
					x_base := x_base + x_ocupado + 3;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- O
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- J
					x_base := x_base + x_ocupado + 3;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+3)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+4)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+4)*2)+1) := '1';
					
					x_ocupado := 5;
					
					-- O
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- G
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- A
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- D
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- O
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- R
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- 1
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					y_ocupado := 5;
					
					-- Vermelho	Verde
					y_base := y_base + y_ocupado + 8;
					
					-- Quadrado
					x_base := 21;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+3)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+3)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+4)*2)+1) := '1';
					
					x_ocupado := 5;
					
					-- V
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- E
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- R
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- M
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+4)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+5)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+5)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+10)*2)  := '1';
					tela((((HORZ_SIZE*y_base)+x_base+10)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+9)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+9)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+8)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+8)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+7)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+7)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+6)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+6)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+11)*2)+1) := '1';
					
					x_ocupado := 12;
					
					-- E
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- L
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- H
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- O
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- Quadrado
					x_base := x_base + x_ocupado + 16;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+3)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+3)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+4)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+4)*2)+1) := '1';
					
					x_ocupado := 5;
					
					-- V
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- E
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- R
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- D
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- E
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';	
		
					x_ocupado := 3;		
					
					y_ocupado := 5;
					-- Botao
					y_base := y_base + y_ocupado + 20;
					x_base := 52;
					for i in 52 to 77 loop
						tela(((HORZ_SIZE*y_base)+i)*2) := '1';
						tela((((HORZ_SIZE*y_base)+i)*2)+1) := '1';
						tela(((HORZ_SIZE*(y_base+1))+i)*2) := '1';
						tela((((HORZ_SIZE*(y_base+1))+i)*2)+1) := '1';
						tela(((HORZ_SIZE*(y_base+2))+i)*2) := '1';
						tela((((HORZ_SIZE*(y_base+2))+i)*2)+1) := '1';
						tela(((HORZ_SIZE*(y_base+3))+i)*2) := '1';
						tela((((HORZ_SIZE*(y_base+3))+i)*2)+1) := '1';
						tela(((HORZ_SIZE*(y_base+4))+i)*2) := '1';
						tela((((HORZ_SIZE*(y_base+4))+i)*2)+1) := '1';
						tela(((HORZ_SIZE*(y_base+5))+i)*2) := '1';
						tela((((HORZ_SIZE*(y_base+5))+i)*2)+1) := '1';
						tela(((HORZ_SIZE*(y_base+6))+i)*2) := '1';
						tela((((HORZ_SIZE*(y_base+6))+i)*2)+1) := '1';
						tela(((HORZ_SIZE*(y_base+7))+i)*2) := '1';
						tela((((HORZ_SIZE*(y_base+7))+i)*2)+1) := '1';
						tela(((HORZ_SIZE*(y_base+8))+i)*2) := '1';
						tela((((HORZ_SIZE*(y_base+8))+i)*2)+1) := '1';
					end loop;
					
					-- JOGAR					
					y_base := y_base + 2;
					
					-- J
					x_base := 54;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+3)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+4)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+4)*2)+1) := '0';
					
					x_ocupado := 5;
					
					-- O
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '0';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '0';
					
					x_ocupado := 4;
					
					-- G
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base))+x_base+3)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+3)*2)+1) := '0';
					
					x_ocupado := 4;
					
					-- A
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+1)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+1)*2)+1) := '0';
					
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '0';
					
					x_ocupado := 3;
					
					-- R
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '0';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '0';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '0';
					
					if modo_jogo = '0' then
						tela(((HORZ_SIZE*26)+31)*2) := '0';
						tela((((HORZ_SIZE*26)+31)*2)+1) := '1';
						tela(((HORZ_SIZE*26)+32)*2) := '0';
						tela((((HORZ_SIZE*26)+32)*2)+1) := '1';
						tela(((HORZ_SIZE*26)+33)*2) := '0';
						tela((((HORZ_SIZE*26)+33)*2)+1) := '1';
						tela(((HORZ_SIZE*27)+31)*2) := '0';
						tela((((HORZ_SIZE*27)+31)*2)+1) := '1';
						tela(((HORZ_SIZE*27)+32)*2) := '0';
						tela((((HORZ_SIZE*27)+32)*2)+1) := '1';
						tela(((HORZ_SIZE*27)+33)*2) := '0';
						tela((((HORZ_SIZE*27)+33)*2)+1) := '1';
						tela(((HORZ_SIZE*28)+31)*2) := '0';
						tela((((HORZ_SIZE*28)+31)*2)+1) := '1';
						tela(((HORZ_SIZE*28)+32)*2) := '0';
						tela((((HORZ_SIZE*28)+32)*2)+1) := '1';
						tela(((HORZ_SIZE*28)+33)*2) := '0';
						tela((((HORZ_SIZE*28)+33)*2)+1) := '1';
					else
						if modo_jogo = '1' then		
							tela(((HORZ_SIZE*26)+76)*2) := '0';
						tela((((HORZ_SIZE*26)+76)*2)+1) := '1';
						tela(((HORZ_SIZE*26)+77)*2) := '0';
						tela((((HORZ_SIZE*26)+77)*2)+1) := '1';
						tela(((HORZ_SIZE*26)+78)*2) := '0';
						tela((((HORZ_SIZE*26)+78)*2)+1) := '1';
						tela(((HORZ_SIZE*27)+76)*2) := '0';
						tela((((HORZ_SIZE*27)+76)*2)+1) := '1';
						tela(((HORZ_SIZE*27)+77)*2) := '0';
						tela((((HORZ_SIZE*27)+77)*2)+1) := '1';
						tela(((HORZ_SIZE*27)+78)*2) := '0';
						tela((((HORZ_SIZE*27)+78)*2)+1) := '1';
						tela(((HORZ_SIZE*28)+76)*2) := '0';
						tela((((HORZ_SIZE*28)+76)*2)+1) := '1';
						tela(((HORZ_SIZE*28)+77)*2) := '0';
						tela((((HORZ_SIZE*28)+77)*2)+1) := '1';
						tela(((HORZ_SIZE*28)+78)*2) := '0';
						tela((((HORZ_SIZE*28)+78)*2)+1) := '1';

						end if;
					end if;
					if first_player = '0' then
						tela(((HORZ_SIZE*60)+22)*2) := '0';
						tela((((HORZ_SIZE*60)+22)*2)+1) := '1';
						tela(((HORZ_SIZE*60)+23)*2) := '0';
						tela((((HORZ_SIZE*60)+23)*2)+1) := '1';
						tela(((HORZ_SIZE*60)+24)*2) := '0';
						tela((((HORZ_SIZE*60)+24)*2)+1) := '1';
						tela(((HORZ_SIZE*61)+22)*2) := '0';
						tela((((HORZ_SIZE*61)+22)*2)+1) := '1';
						tela(((HORZ_SIZE*61)+23)*2) := '0';
						tela((((HORZ_SIZE*61)+23)*2)+1) := '1';
						tela(((HORZ_SIZE*61)+24)*2) := '0';
						tela((((HORZ_SIZE*61)+24)*2)+1) := '1';
						tela(((HORZ_SIZE*62)+22)*2) := '0';
						tela((((HORZ_SIZE*62)+22)*2)+1) := '1';
						tela(((HORZ_SIZE*62)+23)*2) := '0';
						tela((((HORZ_SIZE*62)+23)*2)+1) := '1';
						tela(((HORZ_SIZE*62)+24)*2) := '0';
						tela((((HORZ_SIZE*62)+24)*2)+1) := '1';
					else
						if first_player = '1' then
							tela(((HORZ_SIZE*60)+85)*2) := '0';
						tela((((HORZ_SIZE*60)+85)*2)+1) := '1';
						tela(((HORZ_SIZE*60)+86)*2) := '0';
						tela((((HORZ_SIZE*60)+86)*2)+1) := '1';
						tela(((HORZ_SIZE*60)+87)*2) := '0';
						tela((((HORZ_SIZE*60)+87)*2)+1) := '1';
						tela(((HORZ_SIZE*61)+85)*2) := '0';
						tela((((HORZ_SIZE*61)+85)*2)+1) := '1';
						tela(((HORZ_SIZE*61)+86)*2) := '0';
						tela((((HORZ_SIZE*61)+86)*2)+1) := '1';
						tela(((HORZ_SIZE*61)+87)*2) := '0';
						tela((((HORZ_SIZE*61)+87)*2)+1) := '1';
						tela(((HORZ_SIZE*62)+85)*2) := '0';
						tela((((HORZ_SIZE*62)+85)*2)+1) := '1';
						tela(((HORZ_SIZE*62)+86)*2) := '0';
						tela((((HORZ_SIZE*62)+86)*2)+1) := '1';
						tela(((HORZ_SIZE*62)+87)*2) := '0';
						tela((((HORZ_SIZE*62)+87)*2)+1) := '1';
						end if;
					end if;
					gravar_monitor <= '1';
				when "01" =>
					bit_tela := '0';
					tela := (others => bit_tela);
					
					-- MODO
					y_base := 15;
					
					-- Primeiro barra vertical
					x_base := 50;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+7))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+7))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+8))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+8))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+9))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+9))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+10))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+10))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+11))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+11))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+12))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+12))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+13))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+13))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+14))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+14))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+15))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+15))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+16))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+16))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+17))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+17))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+18))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+18))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+19))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+19))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+20))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+20))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+21))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+21))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+22))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+22))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+23))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+23))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+24))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+24))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+25))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+25))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+26))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+26))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+27))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+27))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+28))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+28))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+29))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+29))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+30))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+30))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+31))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+31))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+32))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+32))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+33))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+33))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+34))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+34))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+35))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+35))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+36))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+36))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+37))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+37))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+38))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+38))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+39))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+39))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+40))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+40))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+41))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+41))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+42))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+42))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+43))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+43))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+44))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+44))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+45))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+45))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+46))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+46))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+47))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+47))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+48))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+48))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+49))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+49))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+50))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+50))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+51))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+51))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+52))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+52))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+53))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+53))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+54))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+54))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+55))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+55))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+56))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+56))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+57))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+57))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+58))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+58))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+59))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+59))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+60))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+60))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+61))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+61))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+62))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+62))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+63))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+63))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+64))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+64))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+65))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+65))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+66))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+66))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+67))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+67))+x_base)*2)+1) := '1';
					
					-- Segunda barra vertical
					x_base := 77;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+7))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+7))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+8))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+8))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+9))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+9))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+10))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+10))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+11))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+11))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+12))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+12))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+13))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+13))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+14))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+14))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+15))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+15))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+16))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+16))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+17))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+17))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+18))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+18))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+19))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+19))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+20))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+20))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+21))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+21))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+22))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+22))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+23))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+23))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+24))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+24))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+25))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+25))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+26))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+26))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+27))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+27))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+28))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+28))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+29))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+29))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+30))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+30))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+31))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+31))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+32))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+32))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+33))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+33))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+34))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+34))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+35))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+35))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+36))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+36))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+37))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+37))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+38))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+38))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+39))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+39))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+40))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+40))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+41))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+41))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+42))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+42))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+43))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+43))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+44))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+44))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+45))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+45))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+46))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+46))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+47))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+47))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+48))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+48))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+49))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+49))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+50))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+50))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+51))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+51))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+52))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+52))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+53))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+53))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+54))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+54))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+55))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+55))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+56))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+56))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+57))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+57))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+58))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+58))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+59))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+59))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+60))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+60))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+61))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+61))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+62))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+62))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+63))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+63))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+64))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+64))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+65))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+65))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+66))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+66))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+67))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+67))+x_base)*2)+1) := '1';
					
					
					-- Primeira linha horizontal
					y_base := 34;
					x_base := 30;
					
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+4)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+5)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+5)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+6)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+6)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+7)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+7)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+8)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+8)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+9)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+9)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+10)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+10)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+12)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+12)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+13)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+13)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+14)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+14)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+15)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+15)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+16)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+16)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+17)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+17)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+18)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+18)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+19)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+19)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+20)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+20)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+21)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+21)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+22)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+22)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+23)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+23)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+24)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+24)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+25)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+25)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+26)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+26)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+27)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+27)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+28)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+28)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+29)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+29)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+30)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+30)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+31)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+31)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+32)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+32)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+33)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+33)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+34)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+34)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+35)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+35)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+36)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+36)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+37)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+37)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+38)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+38)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+39)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+39)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+40)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+40)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+41)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+41)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+42)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+42)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+43)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+43)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+44)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+44)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+45)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+45)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+46)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+46)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+47)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+47)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+48)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+48)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+49)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+49)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+50)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+50)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+51)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+51)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+52)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+52)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+53)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+53)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+54)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+54)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+55)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+55)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+56)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+56)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+57)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+57)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+58)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+58)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+59)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+59)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+60)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+60)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+61)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+61)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+62)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+62)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+63)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+63)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+64)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+64)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+65)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+65)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+66)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+66)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+67)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+67)*2)+1) := '1';
					
					-- Segunda linha horizontal
					y_base := 62;
					x_base := 30;
					
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+4)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+5)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+5)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+6)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+6)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+7)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+7)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+8)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+8)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+9)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+9)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+10)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+10)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+11)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+11)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+12)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+12)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+13)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+13)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+14)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+14)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+15)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+15)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+16)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+16)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+17)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+17)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+18)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+18)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+19)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+19)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+20)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+20)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+21)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+21)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+22)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+22)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+23)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+23)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+24)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+24)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+25)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+25)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+26)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+26)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+27)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+27)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+28)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+28)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+29)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+29)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+30)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+30)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+31)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+31)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+32)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+32)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+33)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+33)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+34)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+34)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+35)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+35)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+36)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+36)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+37)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+37)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+38)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+38)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+39)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+39)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+40)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+40)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+41)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+41)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+42)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+42)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+43)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+43)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+44)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+44)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+45)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+45)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+46)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+46)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+47)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+47)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+48)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+48)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+49)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+49)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+50)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+50)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+51)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+51)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+52)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+52)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+53)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+53)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+54)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+54)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+55)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+55)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+56)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+56)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+57)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+57)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+58)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+58)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+59)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+59)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+60)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+60)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+61)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+61)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+62)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+62)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+63)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+63)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+64)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+64)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+65)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+65)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+66)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+66)*2)+1) := '1';
					tela(((HORZ_SIZE*y_base)+x_base+67)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+67)*2)+1) := '1';
					
					
					if grid_jogo(5 downto 4) = "01" then
											-- Quadrado
					x_base := 36;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;					

					else 
						if grid_jogo(5 downto 4) = "10" then
												-- Quadrado
					x_base := 36;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
						else
							if grid_jogo(5 downto 4) = "00" then
											-- Quadrado
					x_base := 36;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
							else
								if grid_jogo(5 downto 4) = "11" then
											-- Quadrado
					x_base := 36;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;	
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(3 downto 2) = "01" then
																	-- Quadrado
					x_base := 59;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;	
					else 
						if grid_jogo(3 downto 2) = "10" then
												-- Quadrado
					x_base := 59;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;
						else
							if grid_jogo(3 downto 2) = "00" then
											-- Quadrado
					x_base := 59;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
							else
								if grid_jogo(3 downto 2) = "11" then
											-- Quadrado
					x_base := 59;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(1 downto 0) = "01" then
																	-- Quadrado
					x_base := 83;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
					else 
						if grid_jogo(1 downto 0) = "10" then
												-- Quadrado
					x_base := 83;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;
						else
							if grid_jogo(1 downto 0) = "00" then
											-- Quadrado
					x_base := 83;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
							else
								if grid_jogo(1 downto 0) = "11" then
											-- Quadrado
					x_base := 83;
					y_base := 67;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(17 downto 16) = "01" then
																	-- Quadrado
					x_base := 36;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
					else 
						if grid_jogo(17 downto 16) = "10" then
												-- Quadrado
					x_base := 36;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;
						else
							if grid_jogo(17 downto 16) = "00" then
											-- Quadrado
					x_base := 36;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
							else
								if grid_jogo(17 downto 16) = "11" then
											-- Quadrado
					x_base := 36;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(15 downto 14) = "01" then
																	-- Quadrado
					x_base := 59;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
					else 
						if grid_jogo(15 downto 14) = "10" then
												-- Quadrado
					x_base := 59;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;
						else
							if grid_jogo(15 downto 14) = "00" then
											-- Quadrado
					x_base := 59;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
							else
								if grid_jogo(15 downto 14) = "11" then
											-- Quadrado
					x_base := 59;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(13 downto 12) = "01" then
																	-- Quadrado
					x_base := 83;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
					else 
						if grid_jogo(13 downto 12) = "10" then
												-- Quadrado
					x_base := 83;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;
						else
							if grid_jogo(13 downto 12) = "00" then
											-- Quadrado
					x_base := 83;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
							else
								if grid_jogo(13 downto 12) = "11" then
											-- Quadrado
					x_base := 83;
					y_base := 22;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(11 downto 10) = "01" then
																	-- Quadrado
					x_base := 36;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
					else 
						if grid_jogo(11 downto 10) = "10" then
												-- Quadrado
					x_base := 36;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;
						else
							if grid_jogo(11 downto 10) = "00" then
											-- Quadrado
					x_base := 36;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
							else
								if grid_jogo(11 downto 10) = "11" then
											-- Quadrado
					x_base := 36;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(9 downto 8) = "01" then
																	-- Quadrado
					x_base := 59;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
					else 
						if grid_jogo(9 downto 8) = "10" then
												-- Quadrado
					x_base := 59;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;
						else
							if grid_jogo(9 downto 8) = "00" then
											-- Quadrado
					x_base := 59;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
							else
								if grid_jogo(9 downto 8) = "11" then
											-- Quadrado
					x_base := 59;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(7 downto 6) = "01" then
																	-- Quadrado
					x_base := 83;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
					else 
						if grid_jogo(7 downto 6) = "10" then
												-- Quadrado
					x_base := 83;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;
						else
							if grid_jogo(7 downto 6) = "00" then
											-- Quadrado
					x_base := 83;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					end loop;	
							else
								if grid_jogo(7 downto 6) = "11" then
											-- Quadrado
					x_base := 83;
					y_base := 43;
					 for i in 0 to 6 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					end loop;
								end if;
							end if;
						end if;
					end if;
				when "10" =>
					bit_tela := '0';
					tela := (others => bit_tela);					
					if vencedor = "00" then
						-- Velha
						y_base := 45;
						x_base := 54;
						-- V
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- E
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- L
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- H
					x_base := x_base + x_ocupado +1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- A
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;

					else
						-- Vencedor
							y_base := 34;
						x_base := 46;
						
						-- V
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;

										
					-- E
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- N
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+4)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+4)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+5)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+5)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+6)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+6)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+6)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+6)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+6)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+6)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+6)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+6)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+6)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+6)*2)+1) := '1';
					
					x_ocupado := 7;
					
					-- C
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- E
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- D
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
					-- O
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+3)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+3)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+3)*2)+1) := '1';
					
					x_ocupado := 4;
					
					-- R
					x_base := x_base + x_ocupado + 1;
					tela(((HORZ_SIZE*y_base)+x_base)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base)*2)+1) := '1';
					
					tela(((HORZ_SIZE*y_base)+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+1)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+1)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+1)*2)+1) := '1';
					
					tela(((HORZ_SIZE*(y_base+1))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+2)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+2)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+2)*2)+1) := '1';
					
					x_ocupado := 3;
					
						if vencedor = "01" then
							-- Quadrado vermelho
													-- Quadrado
					x_base := 58;
					y_base := 48;
					 for i in 0 to 9 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+7))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+7))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+8))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+8))+x_base+i)*2)+1) := '1';
					tela(((HORZ_SIZE*(y_base+9))+x_base+i)*2) := '0';
					tela((((HORZ_SIZE*(y_base+9))+x_base+i)*2)+1) := '1';
					end loop;	
						else
							if vencedor = "10" then
								-- Quadrado verde
									-- Quadrado
					x_base := 58;
					y_base := 48;
					 for i in 0 to 9 loop
					tela(((HORZ_SIZE*y_base)+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*y_base)+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+1))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+1))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+2))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+2))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+3))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+3))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+4))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+4))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+5))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+5))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+6))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+6))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+7))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+7))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+8))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+8))+x_base+i)*2)+1) := '0';
					tela(((HORZ_SIZE*(y_base+9))+x_base+i)*2) := '1';
					tela((((HORZ_SIZE*(y_base+9))+x_base+i)*2)+1) := '0';
					end loop;
							end if;
						end if;
					end if;
				when others =>
			end case;
			if tela(video_address_tmp*2) = '0' and tela((video_address_tmp*2)+1) = '0' then
				video_word <= "000";
				gravar_monitor <= '1';
			else
				if tela(video_address_tmp*2) = '0' and tela((video_address_tmp*2)+1) = '1' then
					video_word <= "100";
					gravar_monitor <= '1';
				else
					if tela(video_address_tmp*2) = '1' and tela((video_address_tmp*2)+1) = '0' then
						video_word <= "010";
						gravar_monitor <= '1';
					else
						if tela(video_address_tmp*2) = '1' and tela((video_address_tmp*2)+1) = '1' then
							video_word <= "111";
							gravar_monitor <= '1';
						end if;
					end if;
				end if;
			end if;
			video_address <= video_address_tmp;
			mouse_position := (HORZ_SIZE * mouse_y_tmp) + mouse_x_tmp;
			if video_address_tmp = mouse_position then
				video_word <= "001";
				video_address <= video_address_tmp;
				gravar_monitor <= '1';
			end if;
			if video_address_tmp = (HORZ_SIZE * VERT_SIZE - 1) then
				video_address_tmp := 0;
			else
				video_address_tmp := video_address_tmp + 1;
			end if;
		end if;
	end process;
end struct;
