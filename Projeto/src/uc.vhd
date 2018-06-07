LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity uc is
	port
	(
		clock					: in	std_logic;
		resetn				: in	std_logic;
		comando_entrada 	: in 	std_logic_vector(2 downto 0);
		comando_mouse		: out std_logic_vector(2 downto 0);
		comando_monitor	: out std_logic_vector(2 downto 0);
		controle_ram 		: out std_logic
	);
end;

architecture struct of uc is
	type State_type is (PreJogo, Jogando, PosJogo);
	signal estado : State_type;
begin 
	process(clock)
	begin
		if clock'event and clock = '1' then
			if resetn = '0' then
				estado <= PreJogo;
				comando_mouse <= "000";
				comando_monitor <= "000";
				controle_ram <= '0';
			else
				case estado is
					when PreJogo =>
						if comando_entrada = "101" then
							estado <= Jogando;
							comando_mouse <= "000";
							comando_monitor <= "101";
						else 
							if comando_entrada = "001" then
								comando_monitor <= "001";
								comando_mouse <= "001";
							else
								if comando_entrada = "010" then
									comando_monitor <= "010";
									comando_mouse <= "010";
								else
									if comando_entrada = "011" then
										comando_monitor <= "011";
										comando_mouse <= "011";
									else
										if comando_entrada = "100" then
											comando_monitor <= "100";
											comando_mouse <= "100";
										end if;
									end if;
								end if;
							end if;
						end if;
					when Jogando =>
						if comando_entrada = "010" then
							estado <= PosJogo;
							comando_mouse <= "110";
							comando_monitor <= "111";
						else
							if comando_entrada = "001" then
								comando_monitor <= "110";
								comando_mouse <= "101";
							end if;
						end if;
					when PosJogo =>
						if comando_entrada = "001" then
							estado <= PreJogo;
							comando_mouse <= "000";
							comando_monitor <= "000";
						end if;
				end case;
			end if;
		end if;
	end process;	
end struct;
