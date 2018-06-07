LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity atualiza_posicao is
	port
	(
		clock_50mhz	: 	in	STD_LOGIC;
		ps2_data 	:	inout	STD_LOGIC;
		ps2_clock	:	inout	STD_LOGIC;
		resetn	: in std_logic;
		position_x 	: 	out std_logic_vector(7 downto 0);
		position_y 	: 	out std_logic_vector(7 downto 0)
	);
end;

architecture struct of atualiza_posicao is
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
	
	constant SENSIBILITY : integer := 100; -- Rise to decrease sensibility
begin 	
	mousectrl : mouse_ctrl generic map (50000) port map(
		ps2_data, ps2_clock, clock_50mhz, '1', resetn,
		signewdata, bt_on, ox, oy, dx, dy, wheel
	);
	
	-- Atualiza posicao
	process(signewdata, resetn)
		variable xacc, yacc : integer range -10000 to 10000;
	begin
		if(rising_edge(signewdata)) then			
			x <= std_logic_vector(to_signed(to_integer(signed(x)) + ((xacc + to_integer(signed(dx))) / SENSIBILITY), 8));
			y <= std_logic_vector(to_signed(to_integer(signed(y)) + ((yacc + to_integer(signed(dy))) / SENSIBILITY), 8));
			xacc := ((xacc + to_integer(signed(dx))) rem SENSIBILITY);
			yacc := ((yacc + to_integer(signed(dy))) rem SENSIBILITY);
		end if;
		if resetn = '0' then
			xacc := 0;
			yacc := 0;
			x <= (others => '0');
			y <= (others => '0');
		end if;
	end process;
	
	position_x <= x;
	position_y <= y;
end struct;
