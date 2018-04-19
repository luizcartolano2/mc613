library ieee;
use ieee.std_logic_1164.all;

entity dec2_to_4 is
  port(en, w1, w0: in std_logic;
       y3, y2, y1, y0: out std_logic);
end dec2_to_4;

architecture rtl of dec2_to_4 is
    SIGNAL Enw : STD_LOGIC_VECTOR(2 DOWNTO 0) ;
BEGIN
  Enw <= en & w1 & w0;
  
  WITH Enw SELECT
    y0 <= '1' WHEN "100",
      '0' WHEN OTHERS;
  WITH Enw SELECT
    y1 <= '1' WHEN "101",
      '0' WHEN OTHERS;
  WITH Enw SELECT
    y2 <= '1' WHEN "110",
        '0' WHEN OTHERS;
  WITH Enw SELECT
    y3 <= '1' WHEN "111",
        '0' WHEN OTHERS;
END rtl;