LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity imprime_mouse is
	port
	(
		clock_50mhz					: in	STD_LOGIC;
		mouse_position_x			: in 	std_logic_vector(7 downto 0);
		mouse_position_y			: in 	std_logic_vector(7 downto 0);
		rstn							: in 	std_logic;
		vga_r, vga_g, vga_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		vga_hs, vga_vs				: OUT STD_LOGIC;
		vga_blank_n, vga_sync_n : OUT STD_LOGIC;
		vga_clk 						: OUT STD_LOGIC
	);
end;

architecture struct of imprime_mouse is	
	signal pos_x_tmp : std_logic_vector(7 downto 0);
	signal pos_y_tmp : std_logic_vector(7 downto 0);
	COMPONENT vgacon IS
		GENERIC (
			NUM_HORZ_PIXELS : NATURAL := 4;	-- Number of horizontal pixels
			NUM_VERT_PIXELS : NATURAL := 3		-- Number of vertical pixels
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
	
	signal switch, clk50M, sync, blank : std_logic;
	signal mouse_x_tmp : integer range 0 to 3;
	signal mouse_y_tmp : integer range 0 to 2;
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
		write_enable	=> '1'			,
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
		mouse_x_tmp <= 3 when "00000001",
							2 when "00000000",
							1 when "11111111",
							0 when "11111110",
							mouse_x_tmp when others;
							
	with mouse_position_y select
		mouse_y_tmp <= 2 when "11111111",
							1 when "00000000",
							0 when "00000001",
							mouse_y_tmp when others;
				
	process(clock_50mhz)
		variable video_address_tmp : integer RANGE 0 TO HORZ_SIZE * VERT_SIZE - 1;
		variable mouse_position : integer range 0 to HORZ_SIZE * VERT_SIZE - 1;
	begin
		if clock_50mhz'event and clock_50mhz = '1' then
			mouse_position := (4 * mouse_y_tmp) + mouse_x_tmp;
			if video_address_tmp = mouse_position then
				video_word <= "001";
				video_address <= video_address_tmp;
			else
				video_word <= "000";
				video_address <= 8;
			end if;
			if video_address_tmp = (HORZ_SIZE * VERT_SIZE - 1) then
				video_address_tmp := 0;
			else
				video_address_tmp := video_address_tmp + 1;
			end if;
		end if;
	end process;
end struct;
