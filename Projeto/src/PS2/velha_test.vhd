LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity velha_test is
	port
	(
		CLOCK_50	: 	in	STD_LOGIC;	
		PS2_DAT 	:		inout	STD_LOGIC;	--	PS2 Data
		PS2_CLK		:		inout	STD_LOGIC;		--	PS2 Clock
		KEY 	:		in	STD_LOGIC_VECTOR (3 downto 0);		--	Pushbutton[3:0]
		HEX0 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 0
		HEX1 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 1
		HEX2 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 2
		HEX3 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 3
		HEX4 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 3
		HEX5 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 3
		LEDR 	:		out	STD_LOGIC_VECTOR (9 downto 0)		--	LED Red[9:0]
	);
end;

architecture struct of velha_test is
	component position
		port(
		clock_50hz	: 	in	STD_LOGIC;											--	50 MHz
		reset_btn 	:		in	STD_LOGIC;		--	Pushbutton[3:0]
		display_0 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 0
		display_1 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 1
		display_2 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 2
		display_3 	:		out	STD_LOGIC_VECTOR (6 downto 0);		--	Seven Segment Digit 3
		leds 	:		out	STD_LOGIC_VECTOR (9 downto 0);		--	LED Red[9:0]
		data_ps2 	:		inout	STD_LOGIC;	--	PS2 Data
		clock_ps2		:		inout	STD_LOGIC;		--	PS2 Clock
		position_x : out std_logic_vector(7 downto 0);
		position_y : out std_logic_vector(7 downto 0)
		);
	end component;
	
		component bin2hex
		port(
			SW  : in std_logic_vector(3 downto 0);
			HEX0: out std_logic_vector(6 downto 0)
		);
	end component;
	
	signal test_x : std_logic_vector(7 downto 0);
	signal test_y : std_logic_vector(7 downto 0);
begin 
	test_position: position port map(
		CLOCK_50, KEY(0), HEX0, HEX1, HEX2, HEX3, LEDR(9 downto 0), PS2_DAT, PS2_CLK, test_x, test_y
	);
	
	hex_position: bin2hex port map(
		test_x(3 downto 0), HEX4
	);
	
	hex_position2: bin2hex port map(
		test_y(3 downto 0), HEX5
	);
end struct;
