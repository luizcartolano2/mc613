library ieee;
use ieee.std_logic_1164.all;
use work.xbar_gen;

entity xbar_stage_5 is
  port(SW  : in std_logic_vector (4 dox'wnto 0);
       LEDR: out std_logic_vector(0 downto 0));
end xbar_stage_5;

architecture rtl of xbar_stage_5 is
begin
  -- add your code
	instance: xbar_gen 
		GENERIC MAP (N => 5)
		PORT MAP (s => SW, y1 => LEDR(0));
end rtl;
