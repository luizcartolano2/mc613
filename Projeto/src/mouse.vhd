LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity mouse is
	port
	(
		clock : in std_logic;
		ps2_data 	:	inout	STD_LOGIC;
		ps2_clock	:	inout	STD_LOGIC;
		resetn	: in std_logic;
		entrada_mouse : in std_logic_vector(2 downto 0);
		position_x : out std_logic_vector(7 downto 0);
		position_y : out std_logic_vector(7 downto 0);
		comandos_mouse : out std_logic_vector(2 downto 0);
		endereco_ram : out std_logic_vector(1 downto 0);
		saida_ram : in std_logic_vector(5 downto 0);
		dado_ram : out std_logic_vector(5 downto 0);
		estado_mouse : in std_logic_vector(1 downto 0)
	);
end;

architecture struct of mouse is
	component atualiza_posicao
		port(
			clock_50mhz	: 	in	STD_LOGIC;
			ps2_data 	:	inout	STD_LOGIC;
			ps2_clock	:	inout	STD_LOGIC;
			resetn	: in std_logic;
			position_x 	: 	out std_logic_vector(7 downto 0);
			position_y 	: 	out std_logic_vector(7 downto 0)
		);
	end component;
	component valida_clique
		port(
			clock_50mhz	: 	in	STD_LOGIC;
			ps2_data 	:	inout	STD_LOGIC;
			ps2_clock	:	inout	STD_LOGIC;
			resetn	: in std_logic;
			position_x : in std_logic_vector(7 downto 0);
			position_y : in std_logic_vector(7 downto 0);
			comando : out std_logic_vector(2 downto 0);
			endereco_ram : out std_logic_vector(1 downto 0);
			estado_mouse : in std_logic_vector(1 downto 0)
		);
	end component;
	signal local_x, local_y : std_logic_vector(7 downto 0);
begin 	
	recebe_posicao : atualiza_posicao port map (clock, ps2_data, ps2_clock, resetn, local_x, local_y);
	acoes_clique : valida_clique port map (clock, ps2_data, ps2_clock, resetn, local_x, local_y, comandos_mouse, endereco_ram, estado_mouse);
	position_x <= local_x;
	position_y <= local_y;
	
	process(clock)
		variable dado_tmp : std_logic_vector(5 downto 0);
	begin
		if clock'event and clock = '1' then
			if entrada_mouse = "001" then
				if saida_ram(5 downto 4) = "01" then
					dado_tmp := saida_ram;
				else
					dado_tmp := saida_ram XOR "110000";
				end if;
			else
				if entrada_mouse = "011" then
					if saida_ram(3 downto 2) = "01" then
						dado_tmp := saida_ram;
					else
						dado_tmp := saida_ram XOR "001100";
					end if;
				else
					if entrada_mouse = "010" then
						if saida_ram(5 downto 4) = "10" then
							dado_tmp := saida_ram;
						else
							dado_tmp := saida_ram XOR "110000";
						end if;
					else
						if entrada_mouse = "100" then
							if saida_ram(3 downto 2) = "10" then
								dado_tmp := saida_ram;
							else
								dado_tmp := saida_ram XOR "001100";
							end if;
						end if;
					end if;
				end if;
			end if;
			dado_ram <= dado_tmp;
		end if;
	end process;
end struct;
