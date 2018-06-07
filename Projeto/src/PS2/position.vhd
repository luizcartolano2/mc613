LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity position is
	port
	(
		------------------------	Clock Input	 	------------------------
		clock_50hz	: 	in	STD_LOGIC;											--	50 MHz
		
		------------------------	Push Button		------------------------
		reset_btn 	:		in	STD_LOGIC;		--	Pushbutton[3:0]
	
		------------------------	7-SEG Dispaly	------------------------
		display_0 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 0
		display_1 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 1
		display_2 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 2
		display_3 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 3
		
		----------------------------	LED		----------------------------
		leds 	:		out	STD_LOGIC_VECTOR (9 downto 0);		--	LED Red[9:0]
					
		------------------------	PS2		--------------------------------
		data_ps2 	:		inout	STD_LOGIC;	--	PS2 Data
		clock_ps2		:		inout	STD_LOGIC;		--	PS2 Clock
		position_x : out std_logic_vector(7 downto 0);
		position_y : out std_logic_vector(7 downto 0)
	);
end;

architecture struct of position is
	component bin2hex
		port(
			SW  : in std_logic_vector(3 downto 0);
			HEX0: out std_logic_vector(6 downto 0)
		);
	end component;

	component mouse_ctrl
		generic(
			clkfreq : integer
		);
		port(
			ps2_data	:	inout	std_logic;
			ps2_clk		:	inout	std_logic;
			clk				:	in 	std_logic;
			en				:	in 	std_logic;
			resetn		:	in 	std_logic;
			newdata		:	out	std_logic;
			bt_on			:	out	std_logic_vector(2 downto 0);
			ox, oy		:	out std_logic;
			dx, dy		:	out	std_logic_vector(8 downto 0);
			wheel			: out	std_logic_vector(3 downto 0)
		);
	end component;
	
	signal signewdata, resetn : std_logic;
	signal dx, dy : std_logic_vector(8 downto 0);
	signal x, y 	: std_logic_vector(7 downto 0);
	signal hexdata : std_logic_vector(15 downto 0);
	
	constant SENSIBILITY : integer := 16; -- Rise to decrease sensibility
begin 
	-- KEY(0) Reset
	resetn <= reset_btn;
	
	mousectrl : mouse_ctrl generic map (50000) port map(
		data_ps2, clock_ps2, clock_50hz, '1', reset_btn,
		signewdata, leds(7 downto 5), leds(9), leds(8), dx, dy, leds(3 downto 0)
	);
	
	hexseg0: bin2hex port map(
		hexdata(3 downto 0), display_0
	);
	hexseg1: bin2hex port map(
		hexdata(7 downto 4), display_1
	);
	hexseg2: bin2hex port map(
		hexdata(11 downto 8), display_2
	);
	hexseg3: bin2hex port map(
		hexdata(15 downto 12), display_3
	);	
	
	-- Read new mouse data	
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

	hexdata(3  downto  0) <= y(3 downto 0);
	hexdata(7  downto  4) <= y(7 downto 4);
	hexdata(11 downto  8) <= x(3 downto 0);
	hexdata(15 downto 12) <= x(7 downto 4);
	
	position_x <= x;
	position_y <= y;
end struct;
