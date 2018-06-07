LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity imprime_tela is
	port
	(
			clock_50mhz					: in	STD_LOGIC;
			rstn							: in 	std_logic;
			vga_r, vga_g, vga_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			vga_hs, vga_vs				: OUT STD_LOGIC;
			vga_blank_n, vga_sync_n : OUT STD_LOGIC;
			vga_clk 						: OUT STD_LOGIC;
			tela							: in std_logic_vector(2 downto 0)
	);
end;

architecture struct of imprime_tela is	
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
	
	process(clock_50mhz)
		variable video_address_tmp : integer RANGE 0 TO HORZ_SIZE * VERT_SIZE - 1;
	begin
		if clock_50mhz'event and clock_50mhz = '1' then
			case tela is
				when "000" =>
					video_word <= "000";
					video_address <= video_address_tmp;
				when "001" =>
					if video_address_tmp = 0 then
						video_word <= "010";
						video_address <= video_address_tmp;
					else
						if video_address_tmp = 4 then
							video_word <= "000";
							video_address <= video_address_tmp;
						else
							video_word <= "000";
							video_address <= 8;
						end if;
					end if;
				when "010" =>
					if video_address_tmp = 4 then
						video_word <= "010";
						video_address <= video_address_tmp;
					else
						if video_address_tmp = 0 then
							video_word <= "000";
							video_address <= video_address_tmp;
						else
							video_word <= "000";
							video_address <= 8;
						end if;
					end if;
				when "011" =>
					if video_address_tmp = 2 then
						video_word <= "100";
						video_address <= video_address_tmp;
					else
						if video_address_tmp = 6 then
							video_word <= "000";
							video_address <= video_address_tmp;
						else
							video_word <= "000";
							video_address <= 8;
						end if;
					end if;
				when "100" =>
					if video_address_tmp = 6 then
						video_word <= "100";
						video_address <= video_address_tmp;
					else
						if video_address_tmp = 2 then
							video_word <= "000";
							video_address <= video_address_tmp;
						else
							video_word <= "000";
							video_address <= 8;
						end if;
					end if;
				when others =>
					video_word <= "000";
					video_address <= 8;
			end case;
			if video_address_tmp = (HORZ_SIZE * VERT_SIZE - 1) then
				video_address_tmp := 0;
			else
				video_address_tmp := video_address_tmp + 1;
			end if;
		end if;
	end process;
end struct;
