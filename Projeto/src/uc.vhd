LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity uc is
	port
	(
		clock					: in	std_logic;
		reset					: in	std_logic;
		comando_entrada 	: in 	std_logic_vector(2 downto 0);
		comando_mouse		: out std_logic_vector(2 downto 0);
		comando_monitor	: out std_logic_vector(2 downto 0);
	);
end;

architecture struct of uc is
	type State_type is (PreJogo, Jogando, PosJogo);
	signal estado : State_type;
begin 
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				estado <= PreJogo;
			else
				case estado is
					when PreJogo =>
						if comando_entrada = "101" then
							estado <= Jogando;
						end if;
					when Jogando =>
						if comando_entrada = "010" then
							estado <= PosJogo;
						end if;
					when PosJogo =>
						if comando_entrada = "001" then
							estado <= PreJogo;
						end if;
				end case;
			end if;
		end if;
	end process;
	
	process(estado, comando_entrada)
	begin
		case estado is
			when PreJogo =>
				if comando_entrada
		end case;
	end process;
	
end struct;
