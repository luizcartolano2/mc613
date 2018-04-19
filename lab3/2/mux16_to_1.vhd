library ieee;
use ieee.std_logic_1164.all;

entity mux16_to_1 is
  port(data : in std_logic_vector(15 downto 0);
       sel : in std_logic_vector(3 downto 0);
       output : out std_logic);
end mux16_to_1;

architecture rtl of mux16_to_1 is
  SIGNAL first_out : STD_LOGIC_VECTOR(0 TO 3);
  COMPONENT mux4_to_1
    PORT (d3, d2, d1, d0 : IN STD_LOGIC;
       sel : IN STD_LOGIC_VECTOR(1 downto 0);
       output : OUT STD_LOGIC);
  END COMPONENT;
begin
  G1: FOR i IN 0 TO 3 GENERATE
    Muxes: mux4_to_1 PORT MAP (
      data(4*i+3), data(4*i+2), data(4*i+1), data(4*i), sel(1 DOWNTO 0), first_out(i));
  END GENERATE;
  
  Mux5: mux4_to_1 PORT MAP (
    first_out(3), first_out(2), first_out(1), first_out(0), sel(3 DOWNTO 2), output);
end rtl;