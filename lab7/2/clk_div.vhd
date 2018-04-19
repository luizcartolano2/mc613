library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_div is
  port (
    clk : in std_logic;
    clk_hz : out std_logic
  );
end clk_div;

architecture behavioral of clk_div is
  SIGNAL prescaler : UNSIGNED(25 DOWNTO 0);
  SIGNAL temporario : STD_LOGIC;
begin
  PROCESS(clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF prescaler = X"2FAF080" THEN
        prescaler <= (OTHERS => '0');
        temporario <= '1';
      ELSE
        prescaler <= prescaler + 1;
        temporario <= '0';
      END IF;
    END IF;
  END PROCESS;
  
  clk_hz <= temporario;
end behavioral;
