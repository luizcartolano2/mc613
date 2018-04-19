library ieee;
use ieee.std_logic_1164.all;

entity extra_logic is
  port(w3, w2, w1, w0 : in std_logic;
       y3, y2, y1, y0 : in std_logic;
       f : out std_logic);
end extra_logic;

architecture rtl of extra_logic is
  SIGNAL result_e : STD_LOGIC_VECTOR(3 DOWNTO 0);
begin
  result_e(0) <= w0 AND y0;
  result_e(1) <= w1 AND y1;
  result_e(2) <= w2 AND y2;
  result_e(3) <= w3 AND y3;
  f <= result_e(0) OR result_e(1) OR result_e(2) OR result_e(3); 
end rtl;