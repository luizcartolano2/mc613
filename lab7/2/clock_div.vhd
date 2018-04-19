library ieee;
use ieee.std_logic_1164.all;

entity clk_div is
  port (
    clk : in std_logic;
    clk_hz : out std_logic
  );
end clk_div;

architecture behavioral of clk_div is
	signal clk_hz_aux : std_logic;
begin

  process (clk)
		variable counter : integer range 0 to 50000000; 
  begin
		if (rising_edge(clk)) then
			counter := counter + 1;
			
			if (counter = 50000000) then 
				counter := 0;
				clk_hz_aux <= '1';
			elsif (clk_hz_aux = '1') then
				clk_hz_aux <= '0'; 
			end if;
		end if;
  end process;

  clk_hz <= clk_hz_aux;
  
 end behavioral;
