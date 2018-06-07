LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity mouse is
	port
	(
		clock_50hz	: 	in	STD_LOGIC;
		ps2_data 	:	inout	STD_LOGIC;
		ps2_clock	:	inout	STD_LOGIC;
		position_x 	: 	out std_logic_vector(7 downto 0);
		position_y 	: 	out std_logic_vector(7 downto 0)
	);
end;

architecture struct of mouse is
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
	
	constant SENSIBILITY : integer := 32; -- Rise to decrease sensibility
begin 	
	mousectrl : mouse_ctrl generic map (50000) port map(
		ps2_data, ps2_clock, clock_50hz, '1', '1',
		signewdata, bt_on, ox, oy, dx, dy, wheel
	);
	
	-- Atualiza posicao
	process(signewdata)
		variable xacc, yacc : integer range -10000 to 10000;
	begin
		if(rising_edge(signewdata)) then			
			x <= std_logic_vector(to_signed(to_integer(signed(x)) + ((xacc + to_integer(signed(dx))) / SENSIBILITY), 8));
			y <= std_logic_vector(to_signed(to_integer(signed(y)) + ((yacc + to_integer(signed(dy))) / SENSIBILITY), 8));
			xacc := ((xacc + to_integer(signed(dx))) rem SENSIBILITY);
			yacc := ((yacc + to_integer(signed(dy))) rem SENSIBILITY);					
		end if;
		if x < "00000010" then
			if x > "11111101" then
				x <= x;
			else
				x <= "11111110";
			end if;
		else
			x <= "00000001";
		end if;
	
		if y < "00000010" then
			if y > "11111110" then
				y <= y;
			else
				y <= "11111111";
			end if;
		else
			y <= "00000001";
		end if;
	end process;
	
	position_x <= x;
	position_y <= y;
end struct;
