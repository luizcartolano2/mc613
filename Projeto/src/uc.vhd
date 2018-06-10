LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity uc is
	port
	(
		clock					: in	std_logic;
		resetn				: in	std_logic;
		comando_entrada 	: in 	std_logic_vector(3 downto 0);
		comando_mouse		: out std_logic_vector(4 downto 0);
		comando_monitor	: out std_logic_vector(1 downto 0);
		controle_ram 		: out std_logic;
		mouse_validos 		: out std_logic_vector(1 downto 0);
		saida_ram			: in std_logic_vector(5 downto 0)
	);
end;

architecture struct of uc is
	type State_type is (PreJogo, Jogando, PosJogo);
	signal estado : State_type;
	signal controles : std_logic_vector(5 downto 0);
begin 
	process(clock)
		variable cont : integer range 0 to 3;
		variable controle_ram_tmp : std_logic;
		variable turno : integer range 0 to 1;
	begin
		if clock'event and clock = '1' then
			if resetn = '0' then
				estado <= PreJogo;
				comando_mouse <= "00000";
				comando_monitor <= "00";
				controle_ram <= '0';
				controles <= "000000";
				mouse_validos <= "00";
			else
				case estado is
					when PreJogo =>
						--if controle_ram_tmp = '1' then
							--cont := cont + 1;
						--end if;
						--if cont = 3 then
						--	cont := 0;
							controle_ram_tmp := '0';
						--end if;
						comando_monitor <= "00";
						mouse_validos <= "00";
						if comando_entrada = "0101" then
							estado <= Jogando;
							controles <= saida_ram;
							if saida_ram(3 downto 2) = "01" then
								turno := 0;
							else
								if saida_ram(3 downto 2) = "10" then
									turno := 1;
								end if;
							end if;
						else 
							if comando_entrada = "0001" then
								comando_mouse <= "00001";
								controle_ram_tmp := '1';
							else
								if comando_entrada = "0010" then
									comando_mouse <= "00010";
									controle_ram_tmp := '1';
								else
									if comando_entrada = "0011" then
										comando_mouse <= "00011";
										controle_ram_tmp := '1';
									else
										if comando_entrada = "0100" then
											comando_mouse <= "00100";
											controle_ram_tmp := '1';
										else
											if comando_entrada = "0000" then
												comando_mouse <= "00000";
												controle_ram_tmp := '0';
											end if;
										end if;
									end if;
								end if;
							end if;
						end if;
					when Jogando =>
						--if controle_ram_tmp = '1' then
							--cont := cont + 1;
						--end if;
						--if cont = 3 then
						--	cont := 0;
							controle_ram_tmp := '0';
						--end if;
						comando_monitor <= "01";
						mouse_validos <= "01";
						if comando_entrada = "1010" then
							estado <= PosJogo;
							--comando_mouse <= "00110";
						else
							if comando_entrada = "0001" then
								if turno = 0 then
									comando_mouse <= "11111";
									turno := 1;
								else
									comando_mouse <= "00001";
									turno := 0;
								end if;
								controle_ram_tmp := '1';
							else
								if comando_entrada = "0010" then
									if turno = 0 then
										comando_mouse <= "00010";
										turno := 1;
									else
										comando_mouse <= "00011";
										turno := 0;
									end if;
									controle_ram_tmp := '1';
								else
									if comando_entrada = "0011" then
										if turno = 0 then
											comando_mouse <= "00100";
											turno := 1;
										else
											comando_mouse <= "00101";
											turno := 0;
										end if;
										controle_ram_tmp := '1';
									else
										if comando_entrada = "0100" then
											if turno = 0 then
												comando_mouse <= "01000";
												turno := 1;
											else
												comando_mouse <= "01001";
												turno := 0;
											end if;
											controle_ram_tmp := '1';
										else
											if comando_entrada = "0101" then
												if turno = 0 then
													comando_mouse <= "01010";
													turno := 1;
												else
													comando_mouse <= "01011";
													turno := 0;
												end if;
												controle_ram_tmp := '1';
											else
												if comando_entrada = "0110" then
													if turno = 0 then
														comando_mouse <= "01100";
														turno := 1;
													else
														comando_mouse <= "01101";
														turno := 0;
													end if;
													controle_ram_tmp := '1';
												else
													if comando_entrada = "0111" then
														if turno = 0 then
															comando_mouse <= "10000";
															turno := 1;
														else
															comando_mouse <= "10001";
															turno := 0;
														end if;
														controle_ram_tmp := '1';
													else
														if comando_entrada = "1000" then
															if turno = 0 then
																comando_mouse <= "10010";
																turno := 1;
															else
																comando_mouse <= "10011";
																turno := 0;
															end if;
															controle_ram_tmp := '1';
														else
															if comando_entrada = "1001" then
																if turno = 0 then
																	comando_mouse <= "10100";
																	turno := 1;
																else
																	comando_mouse <= "10101";
																	turno := 0;
																end if;
																controle_ram_tmp := '1';
															else
																if comando_entrada = "0000" then
																	comando_mouse <= "00000";
																	controle_ram_tmp := '0';
																end if;
															end if;
														end if;
													end if;
												end if;
											end if;
										end if;
									end if;
								end if;
							end if;
						end if;
					when PosJogo =>
						comando_monitor <= "10";
						mouse_validos <= "10";
						if comando_entrada = "0001" then
							estado <= PreJogo;
							comando_mouse <= "00000";
						end if;
				end case;
			end if;
			controle_ram <= controle_ram_tmp;
		end if;
	end process;	
end struct;
