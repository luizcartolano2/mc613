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
		HEX3 : out std_logic_vector(6 downto 0);
		HEX4 : out std_logic_vector(6 downto 0);
		HEX5 : out std_logic_vector(6 downto 0)
		-- END RETIRAR
	);
end;

architecture struct of velha is
	component mouse
		port(
			clock : in std_logic;
			ps2_data 	:	inout	STD_LOGIC;
			ps2_clock	:	inout	STD_LOGIC;
			resetn	: in std_logic;
			entrada_mouse : in std_logic_vector(4 downto 0);
			position_x : out std_logic_vector(7 downto 0);
			position_y : out std_logic_vector(7 downto 0);
			comandos_mouse : out std_logic_vector(3 downto 0);
			endereco_ram : out std_logic_vector(1 downto 0);
			saida_ram : in std_logic_vector(5 downto 0);
			dado_ram : out std_logic_vector(5 downto 0);
			estado_mouse : in std_logic_vector(1 downto 0);
			ram_linha1	:	in std_logic_vector(5 downto 0);
			ram_linha2	:	in std_logic_vector(5 downto 0);
			ram_linha3	:	in std_logic_vector(5 downto 0)
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
			endereco_ram 				: out std_logic_vector(1 downto 0);
			saida_ram 					: in std_logic_vector(5 downto 0);
			ram_linha1					: out std_logic_vector(5 downto 0);
			ram_linha2					: out std_logic_vector(5 downto 0);
			ram_linha3					: out std_logic_vector(5 downto 0)
		);
	end component;
	component uc
		port(
			clock					: in	std_logic;
			resetn					: in	std_logic;
			comando_entrada 	: in 	std_logic_vector(3 downto 0);
			comando_mouse		: out std_logic_vector(4 downto 0);
			comando_monitor	: out std_logic_vector(1 downto 0);
			controle_ram 		: out std_logic;
			mouse_validos 		: out std_logic_vector(1 downto 0);
			saida_ram			: in std_logic_vector(5 downto 0)
		);
	end component;
	component ram
		port (
			Clock : in std_logic;
			Resetn : in std_logic;
			Address : in std_logic_vector(1 downto 0);
			Data : in std_logic_vector(5 downto 0);
			Q : out std_logic_vector(5 downto 0);
			WrEn : in std_logic
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
	signal entrada : std_logic_vector(3 downto 0);
	signal saida_mouse : std_logic_vector(4 downto 0);
	signal saida_monitor : std_logic_vector(1 downto 0);
	
	signal gravar : std_logic;
	signal endereco_ram : std_logic_vector(1 downto 0);
	signal endereco_mouse : std_logic_vector(1 downto 0);
	signal endereco_monitor : std_logic_vector(1 downto 0);
	signal dado_ram : std_logic_vector(5 downto 0);
	signal saida_ram : std_logic_vector(5 downto 0);
	signal print_f : std_logic_vector(3 downto 0);
	signal print_p : std_logic_vector(3 downto 0);
	signal print_g : std_logic_vector(3 downto 0);
	signal print_e : std_logic_vector(3 downto 0);
	signal print_w : std_logic_vector(3 downto 0);
	signal print_q : std_logic_vector(3 downto 0);
	signal estado_mouse : std_logic_vector(1 downto 0);
	signal ram_linha1 : std_logic_vector(5 downto 0);
	signal ram_linha2 : std_logic_vector(5 downto 0);
	signal ram_linha3 : std_logic_vector(5 downto 0);
begin 
	controle : uc port map(CLOCK_50, KEY(0), entrada, saida_mouse, saida_monitor, gravar, estado_mouse, saida_ram);
	mouse_position : mouse port map(CLOCK_50, PS2_DAT, PS2_CLK, KEY(0), saida_mouse, mouse_x, mouse_y, entrada, endereco_mouse, saida_ram, dado_ram, estado_mouse, ram_linha1, ram_linha2, ram_linha3);
	mouse_monitor : monitor port map(CLOCK_50, mouse_x, mouse_y, KEY(0), VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK, saida_monitor, endereco_monitor, saida_ram, ram_linha1, ram_linha2, ram_linha3);
	memoria : ram port map(CLOCK_50, KEY(0), endereco_ram, dado_ram, saida_ram, gravar);
	
	-- RETIRAR
	--print_f <= "00" & saida_ram(3 downto 2);
	print_f <= ram_linha1(3 downto 0);
	--print_p <= "00" & saida_ram(5 downto 4);
	print_p <= "00" & ram_linha1(5 downto 4);
	--print_g <= "00" & saida_ram(1 downto 0);
	print_g <= "00" & ram_linha2(5 downto 4);
	--print_e <= "00" & endereco_ram;
	print_e <= ram_linha2(3 downto 0);
	--print_w <= "000" & gravar;
	print_w <= "00" & ram_linha3(5 downto 4);
	--print_q <= mouse_x(3 downto 0);
	print_q <= ram_linha3(3 downto 0);
	display1 : bin2hex port map(print_q, HEX0);
	display2 : bin2hex port map(print_w, HEX1);
	display3 : bin2hex port map(print_e, HEX2);
	display4 : bin2hex port map(print_g, HEX3);
	display5 : bin2hex port map(print_f, HEX4);
	display6 : bin2hex port map(print_p, HEX5);
	-- END RETIRAR
	
	process(CLOCK_50)
		variable endereco_tmp : std_logic_vector(1 downto 0);
	begin
		if CLOCK_50'event and CLOCK_50 = '1' then
			if gravar = '1' then
				endereco_tmp := endereco_mouse;
			else
				endereco_tmp := endereco_monitor;
			end if;
			endereco_ram <= endereco_tmp;
		end if;
	end process;
end struct;
