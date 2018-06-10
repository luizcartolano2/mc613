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
	signal mouse_x_tmp : integer range 0 to 3;
	signal mouse_y_tmp : integer range 0 to 2;
begin 	
	mousectrl : mouse_ctrl generic map (50000) port map(
		ps2_data, ps2_clock, clock_50mhz, '1', resetn,
		signewdata, bt_on, ox, oy, dx, dy, wheel
	);
	with position_x select
		mouse_x_tmp <= 3 when "00000001",
							2 when "00000000",
							1 when "11111111",
							0 when "11111110",
							mouse_x_tmp when others;
							
	with position_y select
		mouse_y_tmp <= 2 when "11111111",
							1 when "00000000",
							0 when "00000001",
							mouse_y_tmp when others;
														
	process(signewdata, resetn)
		variable mouse_position : integer range 0 to 4 * 3 - 1;
	begin
		if(rising_edge(signewdata)) then			
			if bt_on(0) = '1' then
				mouse_position := (4 * mouse_y_tmp) + mouse_x_tmp;
				if estado_mouse = "00" then
					case mouse_position is
						when 0 =>
							comando <= "0001";
						when 2 =>
							comando <= "0011";
						when 4 =>
							comando <= "0010";
						when 6 =>
							comando <= "0100";
						when 8 =>
							comando <= "1111";
						when others =>
							comando <= "0000";
					end case;
				else
					if estado_mouse = "01" then
						case mouse_position is
							when 1 =>
								if grid_jogo(17 downto 16) = "00" then
									comando <= "0001";
								end if;
							when 2 =>
								if grid_jogo(15 downto 14) = "00" then
									comando <= "0010";
								end if;
							when 3 =>
								if grid_jogo(13 downto 12) = "00" then
									comando <= "0011";
								end if;
							when 5 =>
								if grid_jogo(11 downto 10) = "00" then
									comando <= "0100";
								end if;
							when 6 =>
								if grid_jogo(9 downto 8) = "00" then
									comando <= "0101";
								end if;
							when 7 =>
								if grid_jogo(7 downto 6) = "00" then
									comando <= "0110";
								end if;
							when 9 =>
								if grid_jogo(5 downto 4) = "00" then
									comando <= "0111";
								end if;
							when 10 =>
								if grid_jogo(3 downto 2) = "00" then
									comando <= "1000";
								end if;
							when 11 =>
								if grid_jogo(1 downto 0) = "00" then
									comando <= "1001";
								end if;
							when others =>
								comando <= "0000";
						end case;
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
