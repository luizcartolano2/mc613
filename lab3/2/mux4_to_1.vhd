library ieee;
use ieee.std_logic_1164.all;

entity mux4_to_1 is
  port(d3, d2, d1, d0 : in std_logic;
       sel : in std_logic_vector(1 downto 0);
       output : out std_logic);
end mux4_to_1;

architecture rtl of mux4_to_1 is
  SIGNAL out_dec : STD_LOGIC_VECTOR(3 DOWNTO 0);
  COMPONENT dec2_to_4
    PORT (en, w1, w0: IN STD_LOGIC;
          y3, y2, y1, y0: OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT extra_logic
    PORT (w3, w2, w1, w0 : IN STD_LOGIC;
          y3, y2, y1, y0 : IN STD_LOGIC;
          f : OUT STD_LOGIC);
  END COMPONENT;
begin
  dec: dec2_to_4 PORT MAP 
        ('1', sel(1), sel(0), out_dec(3), out_dec(2), out_dec(1), out_dec(0));
  extra: extra_logic PORT MAP
        (d3, d2, d1, d0, out_dec(3), out_dec(2), out_dec(1), out_dec(0), output);
end rtl;