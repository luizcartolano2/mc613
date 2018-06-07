LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test IS
	PORT (
		SW				: IN STD_LOGIC_VECTOR(0 downto 0);
		CLOCK_50				: IN STD_LOGIC;
		KEY				: IN STD_LOGIC_VECTOR(0 downto 0);
		VGA_R, VGA_G, VGA_B	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		VGA_HS, VGA_VS		: OUT STD_LOGIC;
		VGA_BLANK_N, VGA_SYNC_N : OUT STD_LOGIC;
		VGA_CLK : OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE behavior OF TEST IS
	signal pos_x_tmp : std_logic_vector(7 downto 0);
	signal pos_y_tmp : std_logic_vector(7 downto 0);
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
	CONSTANT HORZ_SIZE : INTEGER := 4;
	CONSTANT VERT_SIZE : INTEGER := 3;
	
	SIGNAL slow_clock : STD_LOGIC;
	
	SIGNAL clear_video_address	,
		normal_video_address	,
		video_address			: INTEGER RANGE 0 TO HORZ_SIZE * VERT_SIZE - 1;
	
	SIGNAL clear_video_word		,
		normal_video_word		,
		video_word				: STD_LOGIC_VECTOR (2 DOWNTO 0);
	
	TYPE VGA_STATES IS (NORMAL, CLEAR);
	SIGNAL state : VGA_STATES;
	
	signal switch, rstn, clk50M, sync, blank : std_logic;
BEGIN
	switch <= SW(0);
	rstn <= KEY(0);
	clk50M <= CLOCK_50;
	vga_component: vgacon
	GENERIC MAP (
		NUM_HORZ_PIXELS => HORZ_SIZE,
		NUM_VERT_PIXELS => VERT_SIZE
	) PORT MAP (
		clk50M			=> clk50M		,
		rstn			=> rstn		,
		write_clk		=> clk50M		,
		write_enable	=> '1'			,
		write_addr      => video_address,
		vga_clk		=> VGA_CLK,
		data_in         => video_word	,
		red				=> VGA_R		,
		green			=> VGA_G		,
		blue			=> VGA_B		,
		hsync			=> VGA_HS		,
		vsync			=> VGA_VS		,
		sync			=> sync		,
		blank			=> blank
	);
	VGA_SYNC_N <= NOT sync;
	VGA_BLANK_N <= NOT blank;
	
	video_address <= (4*1)+2;
	video_word <= "001";
	
	
END ARCHITECTURE;