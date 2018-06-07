LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity valida_clique is
	port
	(
		clock_50mhz	: 	in	STD_LOGIC;
		ps2_data 	:	inout	STD_LOGIC;
		ps2_clock	:	inout	STD_LOGIC;
		resetn	: in std_logic;
		position_x : in std_logic_vector(7 downto 0);
		position_y : in std_logic_vector(7 downto 0);
		comando : out std_logic_vector(2 downto 0);
		endereco_ram : out std_logic_vector(1 downto 0)
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
	
	constant SENSIBILITY : integer := 100; -- Rise to decrease sensibility
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
							
	-- Atualiza posicao
	process(signewdata, resetn)
		variable mouse_position : integer range 0 to 4 * 3 - 1;
	begin
		if(rising_edge(signewdata)) then			
			if bt_on(0) = '1' then
				mouse_position := (4 * mouse_y_tmp) + mouse_x_tmp;
				case mouse_position is
					when 0 =>
						comando <= "001";
						endereco_ram <= "11";
					when 2 =>
						comando <= "011";
						endereco_ram <= "11";
					when 4 =>
						comando <= "010";
					when 6 =>
						comando <= "100";
					when others =>
						comando <= "000";
				end case;
			else 
				comando <= "000";
			end if;
		end if;
		if resetn = '0' then
			comando <= "000";
		end if;
	end process;
	

end struct;
