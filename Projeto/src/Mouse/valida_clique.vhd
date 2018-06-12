LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity valida_clique is
	port
	(
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
end;

architecture struct of valida_clique is
	component mouse_ctrl
		generic(
			clkfreq : integer
		);
		port(
			ps2_data		:	inout	std_logic;
			ps2_clk		:	inout	std_logic;
			clk			:	in 	std_logic;
			en				:	in 	std_logic;
			resetn		:	in 	std_logic;
			newdata		:	out	std_logic;
			bt_on			:	out	std_logic_vector(2 downto 0);
			ox, oy		:	out 	std_logic;
			dx, dy		:	out	std_logic_vector(8 downto 0);
			wheel			: 	out	std_logic_vector(3 downto 0)
		);
	end component;
	
	signal signewdata : std_logic;
	signal ox, oy 		: std_logic;
	signal bt_on 		: std_logic_vector(2 downto 0);
	signal wheel 		: std_logic_vector(3 downto 0);
	signal x, y 		: std_logic_vector(7 downto 0);
	signal dx, dy 		: std_logic_vector(8 downto 0);
	signal mouse_x_tmp : integer range 0 to 128 - 1;
	signal mouse_y_tmp : integer range 0 to 96 - 1;
	
	CONSTANT HORZ_SIZE : INTEGER := 128;
	CONSTANT VERT_SIZE : INTEGER := 96;
begin 	
	mousectrl : mouse_ctrl generic map (50000) port map(
		ps2_data, ps2_clock, clock_50mhz, '1', resetn,
		signewdata, bt_on, ox, oy, dx, dy, wheel
	);
	
		with position_x select
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
							
	with position_y select
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
														
	process(signewdata, resetn)
		variable mouse_position : integer range 0 to (128 * 96) - 1;
	begin
		if(rising_edge(signewdata)) then			
			if bt_on(0) = '1' then
				mouse_position := (128 * mouse_y_tmp) + mouse_x_tmp;
				if estado_mouse = "00" then

					if mouse_position = ((HORZ_SIZE*(26))+31) then
							comando <= "0001";
						elsif mouse_position = ((HORZ_SIZE*(26))+32) then
							comando <= "0001";
						elsif mouse_position = ((HORZ_SIZE*(26))+33) then
							comando <= "0001";
						elsif mouse_position = ((HORZ_SIZE*(27))+31) then
							comando <= "0001";
						elsif mouse_position = ((HORZ_SIZE*(27))+32) then
							comando <= "0001";
						elsif mouse_position = ((HORZ_SIZE*(27))+33) then
							comando <= "0001";
						elsif mouse_position = ((HORZ_SIZE*(28))+31) then
							comando <= "0001";
						elsif mouse_position = ((HORZ_SIZE*(28))+32) then
							comando <= "0001";
						elsif mouse_position = ((HORZ_SIZE*(28))+33) then
							comando <= "0001";
						elsif mouse_position = ((HORZ_SIZE*(26))+76) then
							comando <= "0010";
						elsif mouse_position = ((HORZ_SIZE*(26))+77) then
							comando <= "0010";
						elsif mouse_position = ((HORZ_SIZE*(26))+78) then
							comando <= "0010";
						elsif mouse_position = ((HORZ_SIZE*(27))+76) then
							comando <= "0010";
						elsif mouse_position = ((HORZ_SIZE*(27))+77) then
							comando <= "0010";
						elsif mouse_position = ((HORZ_SIZE*(27))+78) then
							comando <= "0010";
						elsif mouse_position = ((HORZ_SIZE*(28))+76) then
							comando <= "0010";
						 elsif mouse_position = ((HORZ_SIZE*(28))+77) then
							comando <= "0010";
						 elsif mouse_position = ((HORZ_SIZE*(28))+78) then
							comando <= "0010";
						 elsif mouse_position = ((HORZ_SIZE*(60))+22) then
							comando <= "0011";
						 elsif mouse_position = ((HORZ_SIZE*(60))+23) then
							comando <= "0011";
						 elsif mouse_position = ((HORZ_SIZE*(60))+24) then
							comando <= "0011";
						 elsif mouse_position = ((HORZ_SIZE*(61))+22) then
							comando <= "0011";
						 elsif mouse_position = ((HORZ_SIZE*(61))+23) then
							comando <= "0011";
						 elsif mouse_position = ((HORZ_SIZE*(61))+24) then
							comando <= "0011";
						 elsif mouse_position = ((HORZ_SIZE*(62))+22) then
							comando <= "0011";
						 elsif mouse_position = ((HORZ_SIZE*(62))+23) then
							comando <= "0011";
						 elsif mouse_position = ((HORZ_SIZE*(62))+24) then
							comando <= "0011";
						 elsif mouse_position = ((HORZ_SIZE*(60))+85) then
							comando <= "0100";
						 elsif mouse_position = ((HORZ_SIZE*(60))+86) then
							comando <= "0100";
						 elsif mouse_position = ((HORZ_SIZE*(60))+87) then
							comando <= "0100";
						 elsif mouse_position = ((HORZ_SIZE*(61))+85) then
							comando <= "0100";
						 elsif mouse_position = ((HORZ_SIZE*(61))+86) then
							comando <= "0100";
						elsif mouse_position = ((HORZ_SIZE*(61))+87) then
							comando <= "0100";
						 elsif mouse_position = ((HORZ_SIZE*(62))+85) then
							comando <= "0100";
							 elsif mouse_position = ((HORZ_SIZE*(62))+86) then
							comando <= "0100";
							 elsif mouse_position = ((HORZ_SIZE*(62))+87) then
							comando <= "0100";
						 elsif mouse_y_tmp >= 84 and mouse_y_tmp <= 92 and mouse_x_tmp > 51 and mouse_x_tmp <= 77  then
							comando <= "1111";
						else
							comando <= "0000";
						end if;
					
					

				else
					if estado_mouse = "01" then
						--case mouse_position is
						
							if mouse_y_tmp < 34 and mouse_x_tmp < 50 then
								comando <= "0001";
							elsif mouse_y_tmp < 34 and mouse_x_tmp > 50 and mouse_x_tmp < 77 then
								comando <= "0010";
							elsif mouse_y_tmp < 34 and mouse_x_tmp > 77 then
								comando <= "0011";
							elsif mouse_y_tmp < 62 and mouse_y_tmp > 34 and mouse_x_tmp < 50 then
								comando <= "0100";
							elsif mouse_y_tmp < 62 and mouse_y_tmp > 34 and mouse_x_tmp < 77 and mouse_x_tmp > 50 then
								comando <= "0101";
							elsif mouse_y_tmp < 62 and mouse_y_tmp > 34 and mouse_x_tmp > 77 then
								comando <= "0110";
							elsif mouse_y_tmp > 62 and mouse_y_tmp < 82 and mouse_x_tmp < 50 then
								comando <= "0111";
							elsif mouse_y_tmp > 62 and mouse_y_tmp < 82 and mouse_x_tmp < 77 and mouse_x_tmp > 50 then
								comando <= "1000";
							elsif mouse_y_tmp > 62 and mouse_y_tmp < 82 and mouse_x_tmp > 77 then
								comando <= "1001";
							else
								comando <= "0000";
							end if;
					else
						if estado_mouse = "10" then
						end if;
					end if;
				end if;
			else 
				comando <= "0000";
			end if;
		end if;
		if resetn = '0' then
			comando <= "0000";
		end if;
	end process;
end struct;
