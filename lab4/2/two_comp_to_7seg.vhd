library ieee;
use ieee.std_logic_1164.all;

entity two_comp_to_7seg is
  port (
    bin : in std_logic_vector(3 downto 0);
    segs : out std_logic_vector(6 downto 0);
    neg : out std_logic
  );
end two_comp_to_7seg;

architecture behavioral of two_comp_to_7seg is
  COMPONENT bin2dec
      port (
            VALOR: in std_logic_vector(3 downto 0);
            HEX_GENERIC: out std_logic_vector(6 downto 0)
      );
  END COMPONENT;
begin
  display: bin2dec PORT MAP(bin, segs);
  neg <= bin(3);
end behavioral;