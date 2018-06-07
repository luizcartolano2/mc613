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
		comando_monitor	: out std_logic_vector(1 downto 0);
		controle_ram 		: out std_logic
	);
end;

architecture struct of uc is
	type State_type is (PreJogo, Jogando, PosJogo);
	signal estado : State_type;
begin 
	process(clock)
		variable cont : integer range 0 to 3;
		variable controle_ram_tmp : std_logic;
	begin
		if clock'event and clock = '1' then
			if resetn = '0' then
				estado <= PreJogo;
				comando_mouse <= "000";
				comando_monitor <= "00";
				controle_ram <= '0';
			else
				case estado is
					when PreJogo =>
						if controle_ram_tmp = '1' then
							cont := cont + 1;
						end if;
						if cont = 3 then
							cont := 0;
							controle_ram_tmp := '0';
						end if;
						comando_monitor <= "00";
						if comando_entrada = "101" then
							estado <= Jogando;
							comando_mouse <= "000";
						else 
							if comando_entrada = "001" then
								comando_mouse <= "001";
								controle_ram_tmp := '1';
							else
								if comando_entrada = "010" then
									comando_mouse <= "010";
								else
									if comando_entrada = "011" then
										comando_mouse <= "011";
										controle_ram_tmp := '1';
									else
										if comando_entrada = "100" then
											comando_mouse <= "100";
										end if;
									end if;
								end if;
							end if;
						end if;
					when Jogando =>
						comando_monitor <= "01";
						if comando_entrada = "010" then
							estado <= PosJogo;
							comando_mouse <= "110";
						else
							if comando_entrada = "001" then
								comando_mouse <= "101";
							end if;
						end if;
					when PosJogo =>
						comando_monitor <= "10";
						if comando_entrada = "001" then
							estado <= PreJogo;
							comando_mouse <= "000";
						end if;
				end case;
			end if;
			controle_ram <= controle_ram_tmp;
		end if;
	end process;	
end struct;
