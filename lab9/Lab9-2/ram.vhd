library ieee;
use ieee.std_logic_1164.all;

entity ram is
  port (
    Clock : in std_logic;
    Address : in std_logic_vector(9 downto 0);
    DataIn : in std_logic_vector(31 downto 0);
    DataOut : out std_logic_vector(31 downto 0);
    WrEn : in std_logic
  );
end ram;

architecture rtl of ram is
	component ram_block
		port (Clock : in std_logic;
				Address : in std_logic_vector(6 downto 0);
				Data : in std_logic_vector(7 downto 0);
				Q : out std_logic_vector(7 downto 0);
				WrEn : in std_logic);
	end component;
	signal DataOut_block1 : std_logic_vector(31 downto 0);
	signal DataOut_block2 : std_logic_vector(31 downto 0);
	signal WrEn_block1 : std_logic;
	signal WrEn_block2 : std_logic;
	signal dec_in : std_logic_vector(3 downto 0);
	signal valida_address : std_logic_vector(4 downto 0);
	signal DataOut_tmp : std_logic_vector(31 downto 0);
begin
	dec_in <= WrEn & Address(9 downto 7);
	with dec_in select
		valida_address <= "00001" when "1000",
							"00010" when "1001",
							"00100" when "0000",
							"01000" when "0001",
							"10000" when "0010",
							"10000" when "0011",
							"10000" when "0100",
							"10000" when "0101",
							"10000" when "0110",
							"10000" when "0111",
							"00000" when others;
							
	with valida_address select
		WrEn_block1 <= '1' when "00001",
							'0' when others;
							
	with valida_address select
		WrEn_block2 <= '1' when "00010",
							'0' when others;
							
	with valida_address select
		DataOut_tmp <= DataOut_block1 when "00100",
						DataOut_block2 when "01000",
						"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when "10000",
						DataOut_tmp when others;

	DataOut <= DataOut_tmp;
							
	block1_1: ram_block port map(Clock, Address(6 downto 0), DataIn(31 downto 24), DataOut_block1(31 downto 24), WrEn_block1);
	block1_2: ram_block port map(Clock, Address(6 downto 0), DataIn(23 downto 16), DataOut_block1(23 downto 16), WrEn_block1);
	block1_3: ram_block port map(Clock, Address(6 downto 0), DataIn(15 downto 8), DataOut_block1(15 downto 8), WrEn_block1);
	block1_4: ram_block port map(Clock, Address(6 downto 0), DataIn(7 downto 0), DataOut_block1(7 downto 0), WrEn_block1);
	block2_1: ram_block port map(Clock, Address(6 downto 0), DataIn(31 downto 24), DataOut_block2(31 downto 24), WrEn_block2);
	block2_2: ram_block port map(Clock, Address(6 downto 0), DataIn(23 downto 16), DataOut_block2(23 downto 16), WrEn_block2);
	block2_3: ram_block port map(Clock, Address(6 downto 0), DataIn(15 downto 8), DataOut_block2(15 downto 8), WrEn_block2);
	block2_4: ram_block port map(Clock, Address(6 downto 0), DataIn(7 downto 0), DataOut_block2(7 downto 0), WrEn_block2);	
end rtl;
