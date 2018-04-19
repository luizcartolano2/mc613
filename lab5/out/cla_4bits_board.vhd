-- brief : lab05 - question 2

library ieee;
use ieee.std_logic_1164.all;

entity cla_4bits_board is
  port(
    SW    : in  std_logic_vector(8 downto 0);
    LEDR  : out std_logic_vector(4 downto 0)
  );
end cla_4bits_board;

architecture rtl of cla_4bits_board is
 SIGNAL p : STD_LOGIC_VECTOR(3 DOWNTO 0);
 SIGNAL g : STD_LOGIC_VECTOR(3 DOWNTO 0);
 SIGNAL c : STD_LOGIC_VECTOR(3 DOWNTO 0);
 SIGNAL trash : STD_LOGIC;
 COMPONENT full_adder 
  PORT ( x, y : in std_logic;
    r : out std_logic;
    cin : in std_logic;
    cout : out std_logic);
 END COMPONENT;
begin
p(0) <= SW(0) OR SW(4);
 g(0) <= SW(0) AND SW(4);
 
 p(1) <= SW(1) OR SW(5);
 g(1) <= SW(1) AND SW(5);
 
 p(2) <= SW(2) OR SW(6);
 g(2) <= SW(2) AND SW(6);
 
 p(3) <= SW(3) OR SW(7);
 g(3) <= SW(3) AND SW(7);


c(1) <= g(0) OR (p(0) AND SW(8));
c(2) <= g(1) OR (p(1) AND g(0)) OR (p(1) AND p(0) AND SW(8));
c(3) <= g(2) OR (p(2) AND g(1)) OR (p(2) AND p(1) AND g(0)) OR (p(2) AND p(1) AND p(0) AND SW(8));
LEDR(4) <= g(3) OR (p(3) AND g(2)) OR (p(3) AND p(2) AND g(1)) OR (p(3) AND p(2) AND p(1) AND g(0)) OR (p(3) AND p(2) AND p(1) AND p(0) AND SW(8));

cla0 : full_adder PORT MAP (SW(0), SW(4), LEDR(0), SW(8), trash);
cla1 : full_adder PORT MAP (SW(1), SW(5), LEDR(1), c(1), trash);
cla2 : full_adder PORT MAP (SW(2), SW(6), LEDR(2), c(2), trash);
cla3 : full_adder PORT MAP (SW(3), SW(7), LEDR(3), c(3), trash);
end rtl;




