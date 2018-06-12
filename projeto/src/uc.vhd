LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity uc is
	port
	(
		clock					: in	std_logic;
		resetn				: in	std_logic;
		comando_entrada 	: in 	std_logic_vector(3 downto 0);
		comando_monitor	: out std_logic_vector(1 downto 0);
		mouse_validos 		: out std_logic_vector(1 downto 0);
		grid_jogo			: out std_logic_vector(17 downto 0);
		modo_jogo 			: out std_logic;
		first_player 		: out std_logic;
		vencedor				: out std_logic_vector(1 downto 0);
		ia_ativo				: out std_logic;
		ia_posicao			: in integer range 0 to 9;
		ia_cor				: out std_logic_vector(1 downto 0)
	);
end;

architecture struct of uc is
	type State_type is (PreJogo, Jogando, PosJogo);
	signal estado : State_type;
begin 
	process(clock)
		variable turno : integer range 0 to 1;
		variable grid_jogo_tmp : std_logic_vector(17 downto 0);
		variable modo_jogo_tmp : std_logic;
		variable first_player_tmp : std_logic;
		variable truncar : std_logic_vector(8 downto 0);
		variable vencedor_tmp : std_logic_vector(1 downto 0);
		variable ia_joga	: integer range 0 to 1;
	begin
		if clock'event and clock = '1' then
			if resetn = '0' then
				estado <= PreJogo;
				comando_monitor <= "00";
				mouse_validos <= "00";
				grid_jogo <= "000000000000000000";
				grid_jogo_tmp := "000000000000000000";
				modo_jogo <= '0';
				modo_jogo_tmp := '0';
				first_player <= '0';
				first_player_tmp := '0';
				truncar := "000000000";
				turno := 0;
				vencedor <= "00";
				vencedor_tmp := "00";
				ia_ativo <= '0';
				ia_joga := 0;
			else
				case estado is
					when PreJogo =>
						comando_monitor <= "00";
						mouse_validos <= "00";
						if comando_entrada = "1111" then
							estado <= Jogando;
							if modo_jogo_tmp = '0' then
									turno := 0;
							else
								if modo_jogo_tmp = '1' then
									ia_ativo <= '1';
									if first_player_tmp = '1' then
										ia_joga := 1;
										ia_cor <= "01";
									else
										ia_cor <= "10";
									end if;
								end if;
							end if;
						else 
							if comando_entrada = "0001" then
								modo_jogo_tmp := '0';
							else
								if comando_entrada = "0010" then
									modo_jogo_tmp := '1';
								else
									if comando_entrada = "0011" then
										first_player_tmp := '0';
									else
										if comando_entrada = "0100" then
											first_player_tmp := '1';
										else
											if comando_entrada = "0000" then
											end if;
										end if;
									end if;
								end if;
							end if;
						end if;
					when Jogando =>
						comando_monitor <= "01";
						mouse_validos <= "01";
						if (grid_jogo_tmp(17 downto 16) = grid_jogo_tmp(15 downto 14) and grid_jogo_tmp(15 downto 14) = grid_jogo_tmp(13 downto 12) and grid_jogo_tmp(13 downto 12) = "01")
							or (grid_jogo_tmp(11 downto 10) = grid_jogo_tmp(9 downto 8) and grid_jogo_tmp(9 downto 8) = grid_jogo_tmp(7 downto 6) and grid_jogo_tmp(7 downto 6) = "01")
							or (grid_jogo_tmp(5 downto 4) = grid_jogo_tmp(3 downto 2) and grid_jogo_tmp(3 downto 2) = grid_jogo_tmp(1 downto 0) and grid_jogo_tmp(1 downto 0) = "01")
							or (grid_jogo_tmp(17 downto 16) = grid_jogo_tmp(11 downto 10) and grid_jogo_tmp(11 downto 10) = grid_jogo_tmp(5 downto 4) and grid_jogo_tmp(5 downto 4) = "01")
							or (grid_jogo_tmp(15 downto 14) = grid_jogo_tmp(9 downto 8) and grid_jogo_tmp(9 downto 8) = grid_jogo_tmp(3 downto 2) and grid_jogo_tmp(3 downto 2) = "01")	
							or (grid_jogo_tmp(13 downto 12) = grid_jogo_tmp(7 downto 6) and grid_jogo_tmp(7 downto 6) = grid_jogo_tmp(1 downto 0) and grid_jogo_tmp(1 downto 0) = "01")	
							or (grid_jogo_tmp(17 downto 16) = grid_jogo_tmp(9 downto 8) and grid_jogo_tmp(9 downto 8) = grid_jogo_tmp(1 downto 0) and grid_jogo_tmp(1 downto 0) = "01")	
							or (grid_jogo_tmp(13 downto 12) = grid_jogo_tmp(9 downto 8) and grid_jogo_tmp(9 downto 8) = grid_jogo_tmp(5 downto 4) and grid_jogo_tmp(5 downto 4) = "01")
						then
							estado <= PosJogo;
							vencedor_tmp := "01";
						else
							if (grid_jogo_tmp(17 downto 16) = grid_jogo_tmp(15 downto 14) and grid_jogo_tmp(15 downto 14) = grid_jogo_tmp(13 downto 12) and grid_jogo_tmp(13 downto 12) = "10")
								or (grid_jogo_tmp(11 downto 10) = grid_jogo_tmp(9 downto 8) and grid_jogo_tmp(9 downto 8) = grid_jogo_tmp(7 downto 6) and grid_jogo_tmp(7 downto 6) = "10")
								or (grid_jogo_tmp(5 downto 4) = grid_jogo_tmp(3 downto 2) and grid_jogo_tmp(3 downto 2) = grid_jogo_tmp(1 downto 0) and grid_jogo_tmp(1 downto 0) = "10")
								or (grid_jogo_tmp(17 downto 16) = grid_jogo_tmp(11 downto 10) and grid_jogo_tmp(11 downto 10) = grid_jogo_tmp(5 downto 4) and grid_jogo_tmp(5 downto 4) = "10")
								or (grid_jogo_tmp(15 downto 14) = grid_jogo_tmp(9 downto 8) and grid_jogo_tmp(9 downto 8) = grid_jogo_tmp(3 downto 2) and grid_jogo_tmp(3 downto 2) = "10")
								or (grid_jogo_tmp(13 downto 12) = grid_jogo_tmp(7 downto 6) and grid_jogo_tmp(7 downto 6) = grid_jogo_tmp(1 downto 0) and grid_jogo_tmp(1 downto 0) = "10")	
								or (grid_jogo_tmp(17 downto 16) = grid_jogo_tmp(9 downto 8) and grid_jogo_tmp(9 downto 8) = grid_jogo_tmp(1 downto 0) and grid_jogo_tmp(1 downto 0) = "10")
								or (grid_jogo_tmp(13 downto 12) = grid_jogo_tmp(9 downto 8) and grid_jogo_tmp(9 downto 8) = grid_jogo_tmp(5 downto 4) and grid_jogo_tmp(5 downto 4) = "10")
							then
								estado <= PosJogo;
								vencedor_tmp := "10";
							else
								if grid_jogo_tmp(17 downto 16) /= "00" and grid_jogo_tmp(15 downto 14) /= "00" and grid_jogo_tmp(13 downto 12) /= "00" 
									and grid_jogo_tmp(11 downto 10) /= "00" and grid_jogo_tmp(9 downto 8) /= "00" and grid_jogo_tmp(7 downto 6) /= "00"
									and grid_jogo_tmp(5 downto 4) /= "00" and grid_jogo_tmp(3 downto 2) /= "00" and grid_jogo_tmp(1 downto 0) /= "00"
								then
									estado <= PosJogo;
									vencedor_tmp := "00";
								else
							if comando_entrada = "0001" then
								if truncar(8) = '0' then
									if turno = 0 then
										grid_jogo_tmp(17 downto 16) := "01";
										turno := 1;
									else
										grid_jogo_tmp(17 downto 16) := "10";
										turno := 0;
									end if;
									truncar(8) := '1';
									ia_joga := 1;
								end if;
							else
								if comando_entrada = "0010" then
									if truncar(7) = '0' then
										if turno = 0 then
											grid_jogo_tmp(15 downto 14) := "01";
											turno := 1;
										else
											grid_jogo_tmp(15 downto 14) := "10";
											turno := 0;
										end if;
										truncar(7) := '1';
										ia_joga := 1;
									end if;
								else
									if comando_entrada = "0011" then
										if truncar(6) = '0' then
											if turno = 0 then
												grid_jogo_tmp(13 downto 12) := "01";
												turno := 1;
											else
												grid_jogo_tmp(13 downto 12) := "10";
												turno := 0;
											end if;
											truncar(6) := '1';
											ia_joga := 1;
										end if;
									else
										if comando_entrada = "0100" then
											if truncar(5) = '0' then
												if turno = 0 then
													grid_jogo_tmp(11 downto 10) := "01";
													turno := 1;
												else
													grid_jogo_tmp(11 downto 10) := "10";
													turno := 0;
												end if;
												truncar(5) := '1';
												ia_joga := 1;
											end if;
										else
											if comando_entrada = "0101" then
												if truncar(4) = '0' then
													if turno = 0 then
														grid_jogo_tmp(9 downto 8) := "01";
														turno := 1;
													else
														grid_jogo_tmp(9 downto 8) := "10";
														turno := 0;
													end if;
													truncar(4) := '1';
													ia_joga := 1;
												end if;
											else
												if comando_entrada = "0110" then
													if truncar(3) = '0' then
														if turno = 0 then
															grid_jogo_tmp(7 downto 6) := "01";
															turno := 1;
														else
															grid_jogo_tmp(7 downto 6) := "10";
															turno := 0;
														end if;
														truncar(3) := '1';
														ia_joga := 1;
													end if;
												else
													if comando_entrada = "0111" then
														if truncar(2) = '0' then
															if turno = 0 then
																grid_jogo_tmp(5 downto 4) := "01";
																turno := 1;
															else
																grid_jogo_tmp(5 downto 4) := "10";
																turno := 0;
															end if;
															truncar(2) := '1';
															ia_joga := 1;
														end if;
													else
														if comando_entrada = "1000" then
															if truncar(1) = '0' then
																if turno = 0 then
																	grid_jogo_tmp(3 downto 2) := "01";
																	turno := 1;
																else
																	grid_jogo_tmp(3 downto 2) := "10";
																	turno := 0;
																end if;
																truncar(1) := '1';
																ia_joga := 1;
															end if;
														else
															if comando_entrada = "1001" then
																if truncar(0) = '0' then
																	if turno = 0 then
																		grid_jogo_tmp(1 downto 0) := "01";
																		turno := 1;
																	else
																		grid_jogo_tmp(1 downto 0) := "10";
																		turno := 0;
																	end if;
																	truncar(0) := '1';
																	ia_joga := 1;
																end if;	
															else
																if comando_entrada = "0000" and ia_joga = 1 then
																	if ia_posicao = 1 then
																		if turno = 0 then
																			grid_jogo_tmp(17 downto 16) := "01";
																			turno := 1;
																		else
																			grid_jogo_tmp(17 downto 16) := "10";
																			turno := 0;
																		end if;
																		truncar(8) := '1';
																		ia_joga := 0;
																	else
																		if ia_posicao = 2 then
																			if turno = 0 then
																				grid_jogo_tmp(15 downto 14) := "01";
																				turno := 1;
																			else
																				grid_jogo_tmp(15 downto 14) := "10";
																				turno := 0;
																			end if;
																			truncar(7) := '1';
																			ia_joga := 0;
																		else
																			if ia_posicao = 3 then
																				if turno = 0 then
																					grid_jogo_tmp(13 downto 12) := "01";
																					turno := 1;
																				else
																					grid_jogo_tmp(13 downto 12) := "10";
																					turno := 0;
																				end if;
																				truncar(6) := '1';
																				ia_joga := 0;
																			else
																				if ia_posicao = 4 then
																					if turno = 0 then
																						grid_jogo_tmp(11 downto 10) := "01";
																						turno := 1;
																					else
																						grid_jogo_tmp(11 downto 10) := "10";
																						turno := 0;
																					end if;
																					truncar(5) := '1';
																					ia_joga := 0;
																				else
																					if ia_posicao = 5 then
																						if turno = 0 then
																							grid_jogo_tmp(9 downto 8) := "01";
																							turno := 1;
																						else
																							grid_jogo_tmp(9 downto 8) := "10";
																							turno := 0;
																						end if;
																						truncar(4) := '1';
																						ia_joga := 0;
																					else
																						if ia_posicao = 6 then
																							if turno = 0 then
																								grid_jogo_tmp(7 downto 6) := "01";
																								turno := 1;
																							else
																								grid_jogo_tmp(7 downto 6) := "10";
																								turno := 0;
																							end if;
																							truncar(3) := '1';
																							ia_joga := 0;
																						else
																							if ia_posicao = 7 then
																								if turno = 0 then
																									grid_jogo_tmp(5 downto 4) := "01";
																									turno := 1;
																								else
																									grid_jogo_tmp(5 downto 4) := "10";
																									turno := 0;
																								end if;
																								truncar(2) := '1';
																								ia_joga := 0;
																							else
																								if ia_posicao = 8 then
																									if turno = 0 then
																										grid_jogo_tmp(3 downto 2) := "01";
																										turno := 1;
																									else
																										grid_jogo_tmp(3 downto 2) := "10";
																										turno := 0;
																									end if;
																									truncar(1) := '1';
																									ia_joga := 0;
																								else
																									if ia_posicao = 9 then
																										if turno = 0 then
																											grid_jogo_tmp(1 downto 0) := "01";
																											turno := 1;
																										else
																											grid_jogo_tmp(1 downto 0) := "10";
																											turno := 0;
																										end if;
																										truncar(0) := '1';
																										ia_joga := 0;
																									else
																										if ia_posicao = 0 then
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
						end if;	
					when PosJogo =>
						comando_monitor <= "10";
				end case;
			end if;
			vencedor <= vencedor_tmp;
			grid_jogo <= grid_jogo_tmp;
			modo_jogo <= modo_jogo_tmp;
			first_player <= first_player_tmp;
		end if;
	end process;	
end struct;
