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
	signal gravar_monitor : std_logic;
	
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
		variable tela : std_logic_vector(0 to ((HORZ_SIZE * VERT_SIZE * 2) - 1));
		variable bit_tela : std_logic;
	begin
		if clock_50mhz'event and clock_50mhz = '1' then		
			gravar_monitor <= '0';
			case entrada_monitor is
				when "00" =>
					bit_tela := '0';
					tela := (others => bit_tela);
					tela(8*2) := '1';
					tela((8*2)+1) := '1';
					if modo_jogo = '0' then
						tela(0*2) := '0';
						tela(4*2) := '0';
						tela((0*2)+1) := '1';
						tela((4*2)+1) := '0';
					else
						if modo_jogo = '1' then
							tela(4*2) := '0';
							tela(0*2) := '0';
							tela((0*2)+1) := '0';
							tela((4*2)+1) := '1';
						end if;
					end if;
					if first_player = '0' then
						tela(2*2) := '0';
						tela(6*2) := '0';
						tela((2*2)+1) := '1';
						tela((6*2)+1) := '0';
					else
						if first_player = '1' then
							tela(6*2) := '0';
							tela(2*2) := '0';
							tela((2*2)+1) := '0';
							tela((6*2)+1) := '1';
						end if;
					end if;
					gravar_monitor <= '1';
				when "01" =>
					bit_tela := '0';
					tela := (others => bit_tela);
					if grid_jogo(5 downto 4) = "01" then
						tela(9*2) := '0';
						tela((9*2)+1) := '1';
					else 
						if grid_jogo(5 downto 4) = "10" then
							tela(9*2) := '1';
							tela((9*2)+1) := '0';
						else
							if grid_jogo(5 downto 4) = "00" then
								tela(9*2) := '0';
								tela((9*2)+1) := '0';
							else
								if grid_jogo(5 downto 4) = "11" then
									tela(9*2) := '1';
									tela((9*2)+1) := '1';
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(3 downto 2) = "01" then
						tela(10*2) := '0';
						tela((10*2)+1) := '1';
					else 
						if grid_jogo(3 downto 2) = "10" then
							tela(10*2) := '1';
							tela((10*2)+1) := '0';
						else
							if grid_jogo(3 downto 2) = "00" then
								tela(10*2) := '0';
								tela((10*2)+1) := '0';
							else
								if grid_jogo(3 downto 2) = "11" then
									tela(10*2) := '1';
									tela((10*2)+1) := '1';
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(1 downto 0) = "01" then
						tela(11*2) := '0';
						tela((11*2)+1) := '1';
					else 
						if grid_jogo(1 downto 0) = "10" then
							tela(11*2) := '1';
							tela((11*2)+1) := '0';
						else
							if grid_jogo(1 downto 0) = "00" then
								tela(11*2) := '0';
								tela((11*2)+1) := '0';
							else
								if grid_jogo(1 downto 0) = "11" then
									tela(11*2) := '1';
									tela((11*2)+1) := '1';
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(17 downto 16) = "01" then
						tela(1*2) := '0';
						tela((1*2)+1) := '1';
					else 
						if grid_jogo(17 downto 16) = "10" then
							tela(1*2) := '1';
							tela((1*2)+1) := '0';
						else
							if grid_jogo(17 downto 16) = "00" then
								tela(1*2) := '0';
								tela((1*2)+1) := '0';
							else
								if grid_jogo(17 downto 16) = "11" then
									tela(1*2) := '1';
									tela((1*2)+1) := '1';
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(15 downto 14) = "01" then
						tela(2*2) := '0';
						tela((2*2)+1) := '1';
					else 
						if grid_jogo(15 downto 14) = "10" then
							tela(2*2) := '1';
							tela((2*2)+1) := '0';
						else
							if grid_jogo(15 downto 14) = "00" then
								tela(2*2) := '0';
								tela((2*2)+1) := '0';
							else
								if grid_jogo(15 downto 14) = "11" then
									tela(2*2) := '1';
									tela((2*2)+1) := '1';
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(13 downto 12) = "01" then
						tela(3*2) := '0';
						tela((3*2)+1) := '1';
					else 
						if grid_jogo(13 downto 12) = "10" then
							tela(3*2) := '1';
							tela((3*2)+1) := '0';
						else
							if grid_jogo(13 downto 12) = "00" then
								tela(3*2) := '0';
								tela((3*2)+1) := '0';
							else
								if grid_jogo(13 downto 12) = "11" then
									tela(3*2) := '1';
									tela((3*2)+1) := '1';
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(11 downto 10) = "01" then
						tela(5*2) := '0';
						tela((5*2)+1) := '1';
					else 
						if grid_jogo(11 downto 10) = "10" then
							tela(5*2) := '1';
							tela((5*2)+1) := '0';
						else
							if grid_jogo(11 downto 10) = "00" then
								tela(5*2) := '0';
								tela((5*2)+1) := '0';
							else
								if grid_jogo(11 downto 10) = "11" then
									tela(5*2) := '1';
									tela((5*2)+1) := '1';
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(9 downto 8) = "01" then
						tela(6*2) := '0';
						tela((6*2)+1) := '1';
					else 
						if grid_jogo(9 downto 8) = "10" then
							tela(6*2) := '1';
							tela((6*2)+1) := '0';
						else
							if grid_jogo(9 downto 8) = "00" then
								tela(6*2) := '0';
								tela((6*2)+1) := '0';
							else
								if grid_jogo(9 downto 8) = "11" then
									tela(6*2) := '1';
									tela((6*2)+1) := '1';
								end if;
							end if;
						end if;
					end if;
					if grid_jogo(7 downto 6) = "01" then
						tela(7*2) := '0';
						tela((7*2)+1) := '1';
					else 
						if grid_jogo(7 downto 6) = "10" then
							tela(7*2) := '1';
							tela((7*2)+1) := '0';
						else
							if grid_jogo(7 downto 6) = "00" then
								tela(7*2) := '0';
								tela((7*2)+1) := '0';
							else
								if grid_jogo(7 downto 6) = "11" then
									tela(7*2) := '1';
									tela((7*2)+1) := '1';
								end if;
							end if;
						end if;
					end if;
				when "10" =>
					bit_tela := '0';
					tela := (others => bit_tela);
					if vencedor = "00" then
						tela(4*2) := '1';
						tela((4*2)+1) := '1';
					else
						if vencedor = "01" then
							tela(4*2) := '0';
							tela((4*2)+1) := '1';
						else
							if vencedor = "10" then
								tela(4*2) := '1';
								tela((4*2)+1) := '0';
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
			mouse_position := (4 * mouse_y_tmp) + mouse_x_tmp;
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
