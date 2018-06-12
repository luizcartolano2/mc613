library ieee;
use ieee.std_logic_1164.all;

entity ia is
	port(
		ativo			: in std_logic;
		gride_jogo	: in std_logic_vector(17 downto 0);
		posicao		: out integer range 0 to 9;
		ia_cor		: in std_logic_vector(1 downto 0)
	);
end ia;

architecture struct of ia is
begin
		process(gride_jogo)
			variable posicao_tmp: integer;
			variable ia_corn : std_logic_vector(1 downto 0);
		begin
		if ativo = '1' then
			ia_corn := ia_cor xor "11";
		--vitoria na horizontal
			-- primeira linha
			if(gride_jogo(15 downto 14) = gride_jogo(13 downto 12) and gride_jogo(15 downto 14)= ia_cor and gride_jogo(17 downto 16) = "00") then
				posicao <= 1;
			else
				if(gride_jogo(17 downto 16) = gride_jogo(13 downto 12) and gride_jogo(17 downto 16)= ia_cor and gride_jogo(15 downto 14) = "00") then
					posicao <= 2;
				else
					if(gride_jogo(17 downto 16) = gride_jogo(15 downto 14) and gride_jogo(17 downto 16)= ia_cor and gride_jogo(13 downto 12) = "00") then
						posicao <= 3;
					-- segunda linha
					else
						if(gride_jogo(9 downto 8) = gride_jogo(7 downto 6) and gride_jogo(9 downto 8)= ia_cor and gride_jogo(11 downto 10) = "00") then
							posicao <= 4;
						else
							if(gride_jogo(11 downto 10) = gride_jogo(7 downto 6) and gride_jogo(11 downto 10)= ia_cor and gride_jogo(9 downto 8) = "00") then
								posicao <= 5;
							else
								if(gride_jogo(11 downto 10) = gride_jogo(9 downto 8) and gride_jogo(11 downto 10)= ia_cor and gride_jogo(7 downto 6) = "00") then
									posicao <= 6;
								-- terceira linha
								else
									if(gride_jogo(3 downto 2) = gride_jogo(1 downto 0) and gride_jogo(3 downto 2)= ia_cor and gride_jogo(5 downto 4) = "00") then
											posicao <= 7;
									else
										if(gride_jogo(5 downto 4) = gride_jogo(1 downto 0) and gride_jogo(5 downto 4)= ia_cor and gride_jogo(3 downto 2) = "00") then
											posicao <= 8;
										else
											if(gride_jogo(5 downto 4) = gride_jogo(3 downto 2) and gride_jogo(5 downto 4)= ia_cor and gride_jogo(1 downto 0) = "00") then
												posicao <= 9;
												--vitoria na vertical
												-- primeira coluna
												else
													if(gride_jogo(11 downto 10) = gride_jogo(5 downto 4) and gride_jogo(11 downto 10)= ia_cor and gride_jogo(17 downto 16) = "00") then
														posicao <= 1;
													else
														if(gride_jogo(17 downto 16) = gride_jogo(5 downto 4) and gride_jogo(17 downto 16)= ia_cor and gride_jogo(11 downto 10) = "00") then
															posicao <= 4;
														else
															if(gride_jogo(17 downto 16) = gride_jogo(11 downto 10) and gride_jogo(17 downto 16)= ia_cor and gride_jogo(5 downto 4) = "00") then
																posicao <= 7;
															-- segunda coluna
															else
																if(gride_jogo(9 downto 8) = gride_jogo(3 downto 2) and gride_jogo(9 downto 8)= ia_cor and gride_jogo(15 downto 14) = "00") then
																	posicao <= 2;
																else
																	if(gride_jogo(15 downto 14) = gride_jogo(3 downto 2) and gride_jogo(15 downto 14)= ia_cor and gride_jogo(9 downto 8) = "00") then
																		posicao <= 5;
																	else
																		if(gride_jogo(15 downto 14) = gride_jogo(9 downto 8) and gride_jogo(15 downto 14)= ia_cor and gride_jogo(3 downto 2) = "00") then
																			posicao <= 8;
																		-- terceira coluna
																		else
																			if(gride_jogo(7 downto 6) = gride_jogo(1 downto 0) and gride_jogo(7 downto 6)= ia_cor and gride_jogo(13 downto 12) = "00") then
																				posicao <= 3;
																			else
																				if(gride_jogo(13 downto 12) = gride_jogo(1 downto 0) and gride_jogo(13 downto 12)= ia_cor and gride_jogo(7 downto 6) = "00") then
																					posicao <= 6;
																				else
																					if(gride_jogo(13 downto 12) = gride_jogo(7 downto 6) and gride_jogo(13 downto 12)= ia_cor and gride_jogo(1 downto 0) = "00") then
																						posicao <= 9;
																					-- vitoria na diagonal
																					--canto superior esquerdo para o canto inferior direito
																					else
																						if(gride_jogo(9 downto 8) = gride_jogo(1 downto 0) and gride_jogo(9 downto 8)= ia_cor and gride_jogo(17 downto 16) = "00") then
																							posicao <= 1;
																						else
																							if(gride_jogo(17 downto 16) = gride_jogo(1 downto 0) and gride_jogo(17 downto 16)= ia_cor and gride_jogo(9 downto 8) = "00") then
																									posicao <= 5;
																							else
																								if(gride_jogo(17 downto 16) = gride_jogo(9 downto 8) and gride_jogo(17 downto 16)= ia_cor and gride_jogo(1 downto 0) = "00") then
																										posicao <= 9;
																								--canto superior direito para o canto inferior esquerdo
																								else
																									if(gride_jogo(9 downto 8) = gride_jogo(5 downto 4) and gride_jogo(9 downto 8)= ia_cor and gride_jogo(13 downto 12) = "00") then
																											posicao <= 3;
																									else
																										if(gride_jogo(13 downto 12) = gride_jogo(5 downto 4) and gride_jogo(13 downto 12)= ia_cor and gride_jogo(9 downto 8) = "00") then
																												posicao <= 5;
																										else
																											if(gride_jogo(13 downto 12) = gride_jogo(9 downto 8) and gride_jogo(13 downto 12)= ia_cor and gride_jogo(5 downto 4) = "00") then
																													posicao <= 7;
																											-- impedir derrota na horizontal
																												-- primeira linha
																											else
																												if(gride_jogo(15 downto 14) = gride_jogo(13 downto 12) and gride_jogo(15 downto 14) = ia_corn and gride_jogo(17 downto 16) = "00") then
																														posicao <= 1;
																												else
																													if(gride_jogo(17 downto 16) = gride_jogo(13 downto 12) and gride_jogo(17 downto 16) = ia_corn and gride_jogo(15 downto 14) = "00") then
																															posicao <= 2;
																													else
																														if(gride_jogo(17 downto 16) = gride_jogo(15 downto 14) and gride_jogo(17 downto 16) = ia_corn and gride_jogo(13 downto 12) = "00") then
																																posicao <= 3;
																															-- segunda linha
																														else
																															if(gride_jogo(9 downto 8) = gride_jogo(7 downto 6) and gride_jogo(9 downto 8) = ia_corn and gride_jogo(11 downto 10) = "00") then
																																		posicao <= 4;
																															else
																																if(gride_jogo(11 downto 10) = gride_jogo(7 downto 6) and gride_jogo(11 downto 10) = ia_corn and gride_jogo(9 downto 8) = "00") then
																																			posicao <= 5;
																																else
																																	if(gride_jogo(11 downto 10) = gride_jogo(9 downto 8) and gride_jogo(11 downto 10) = ia_corn and gride_jogo(7 downto 6) = "00") then
																																				posicao <= 6;
																																	-- terceira linha
																																	else
																																		if(gride_jogo(3 downto 2) = gride_jogo(1 downto 0) and gride_jogo(3 downto 2) = ia_corn and gride_jogo(5 downto 4) = "00") then
																																					posicao <= 7;
																																		else
																																			if(gride_jogo(5 downto 4) = gride_jogo(1 downto 0) and gride_jogo(5 downto 4) = ia_corn and gride_jogo(3 downto 2) = "00") then
																																						posicao <= 8;
																																			else
																																				if(gride_jogo(5 downto 4) = gride_jogo(3 downto 2) and gride_jogo(5 downto 4) = ia_corn and gride_jogo(1 downto 0) = "00") then
																																							posicao <= 9;
																																				--impedir derrota na vertical
																																				-- primeira coluna
																																				else
																																					if(gride_jogo(11 downto 10) = gride_jogo(5 downto 4) and gride_jogo(11 downto 10) = ia_corn and gride_jogo(17 downto 16) = "00") then
																																								posicao <= 1;
																																					else
																																						if(gride_jogo(17 downto 16) = gride_jogo(5 downto 4) and gride_jogo(17 downto 16) = ia_corn and gride_jogo(11 downto 10) = "00") then
																																									posicao <= 4;
																																						else
																																							if(gride_jogo(17 downto 16) = gride_jogo(11 downto 10) and gride_jogo(17 downto 16) = ia_corn and gride_jogo(5 downto 4) = "00") then
																																										posicao <= 7;
																																							-- segunda linha
																																							else
																																								if(gride_jogo(9 downto 8) = gride_jogo(3 downto 2) and gride_jogo(9 downto 8) = ia_corn and gride_jogo(15 downto 14) = "00") then
																																											posicao <= 2;
																																								else
																																									if(gride_jogo(15 downto 14) = gride_jogo(3 downto 2) and gride_jogo(15 downto 14) = ia_corn and gride_jogo(9 downto 8) = "00") then
																																												posicao <= 5;
																																									else
																																										if(gride_jogo(15 downto 14) = gride_jogo(9 downto 8) and gride_jogo(15 downto 14) = ia_corn and gride_jogo(3 downto 2) = "00") then
																																													posicao <= 8;
																																										-- terceira coluna
																																										else
																																											if(gride_jogo(7 downto 6) = gride_jogo(1 downto 0) and gride_jogo(7 downto 6) = ia_corn and gride_jogo(13 downto 12) = "00") then
																																														posicao <= 3;
																																											else
																																												if(gride_jogo(13 downto 12) = gride_jogo(1 downto 0) and gride_jogo(13 downto 12) = ia_corn and gride_jogo(7 downto 6) = "00") then
																																															posicao <= 6;
																																												else
																																													if(gride_jogo(13 downto 12) = gride_jogo(7 downto 6) and gride_jogo(13 downto 12) = ia_corn and gride_jogo(1 downto 0) = "00") then
																																																posicao <= 9;
																																													--impedir derrota na diagonal
																																													--canto superior esquerdo para canto inferior direito
																																													else
																																														if(gride_jogo(9 downto 8) = gride_jogo(1 downto 0) and gride_jogo(9 downto 8) = ia_corn and gride_jogo(17 downto 16) = "00") then
																																																	posicao <= 1;
																																														else
																																															if(gride_jogo(17 downto 16) = gride_jogo(1 downto 0) and gride_jogo(17 downto 16) = ia_corn and gride_jogo(9 downto 8) = "00") then
																																																		posicao <= 5;
																																															else
																																																if(gride_jogo(17 downto 16) = gride_jogo(9 downto 8) and gride_jogo(17 downto 16) = ia_corn and gride_jogo(1 downto 0) = "00") then
																																																			posicao <= 9;
																																																-- canto superior direito para canto inferior esquerdo
																																																else
																																																	if(gride_jogo(9 downto 8) = gride_jogo(5 downto 4) and gride_jogo(9 downto 8) = ia_corn and gride_jogo(13 downto 12) = "00") then
																																																				posicao <= 3;
																																																	else
																																																		if(gride_jogo(13 downto 12) = gride_jogo(5 downto 4) and gride_jogo(13 downto 12) = ia_corn and gride_jogo(9 downto 8) = "00") then
																																																					posicao <= 5;
																																																		else
																																																			if(gride_jogo(13 downto 12) = gride_jogo(9 downto 8) and gride_jogo(13 downto 12) = ia_corn and gride_jogo(5 downto 4) = "00") then
																																																						posicao <= 7;
																																																	
																																																				-- se o canto superior esquerdo estiver ocupado tenta ocupar o canto inferior direito (caso livre)
																																																				else
																																																					if gride_jogo(17 downto 16) = ia_corn and gride_jogo(1 downto 0) = "00" then
																																																								posicao <= 9;
																																																					-- se o canto superior direito estiver ocupado tenta ocupar o canto inferior esquerdo (caso livre)
																																																					else
																																																					if gride_jogo(13 downto 12) = ia_corn and gride_jogo(5 downto 4) = "00" then
																																																									posicao <= 7;
																																																					-- se o canto inferior esquerdo estiver ocupado tenta ocupar o canto superior direito (caso livre)
																																																					else
																																																						if gride_jogo(5 downto 4) = ia_corn and gride_jogo(13 downto 12) = "00" then
																																																										posicao <= 3;
																																																						-- se o canto inferior direito estiver ocupado tenta ocupar o canto superior esquerdo (caso livre)
																																																						else
																																																							if gride_jogo(1 downto 0) = ia_corn and gride_jogo(17 downto 16) = "00" then
																																																											posicao <= 1;
																																																												-- tenta ocupar o centro
																																																			else
																																																				if gride_jogo(9 downto 8) = "00" then
																																																							posicao <= 5;
																																																							-- tenta ocupar o canto superior esquerdo
																																																							else
																																																								if gride_jogo(17 downto 16) = "00" then
																																																												posicao <= 1;
																																																								-- tenta ocupar o canto superior direito
																																																								else
																																																									if gride_jogo(13 downto 12) = "00" then
																																																													posicao <= 3;
																																																									-- tenta ocupar o canto inferior esquerdo
																																																									else
																																																										if gride_jogo(5 downto 4) = "00" then
																																																														posicao <= 7;
																																																										-- tenta ocupar o canto inferior direito
																																																										else
																																																											if gride_jogo(1 downto 0) = "00" then
																																																															posicao <= 9;
																																																											-- joga de maneira aleatoria ocupando qualquer espaco livre
																																																											else
																																																												if gride_jogo(15 downto 14) = "00" then
																																																																posicao <= 2;
																																																												else
																																																													if gride_jogo(11 downto 10) = "00" then
																																																																	posicao <= 4;
																																																													else
																																																														if gride_jogo(7 downto 6) = "00" then
																																																																		posicao <= 6;
																																																														else
																																																															if gride_jogo(3 downto 2) = "00" then
																																																																			posicao <= 8;
																																																															else
																																																																posicao <= 0;
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
		else
			posicao <= 0;
		end if;
	end process;
end struct;

