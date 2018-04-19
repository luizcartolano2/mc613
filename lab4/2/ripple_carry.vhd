library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry is
  generic (
    N : integer := 4
  );
  port (
    x,y : in std_logic_vector(N-1 downto 0);
    r : out std_logic_vector(N-1 downto 0);
    cin : in std_logic;
    cout : out std_logic;
    overflow : out std_logic
  );
end ripple_carry;

architecture rtl of ripple_carry is
	SIGNAL carry : STD_LOGIC_VECTOR(0 TO N);
	COMPONENT full_adder
		PORT (x, y : in std_logic;
				r : out std_logic;
				cin : in std_logic;
				cout : out std_logic);
	END COMPONENT;
begin
  -- add your code
	carry(0) <= cin;
	ripple: 
	FOR i IN 0 TO N-1 GENERATE
		n_adder: full_adder PORT MAP (x(i), y(i), r(i), carry(i), carry(i+1));
	END GENERATE;
	cout <= carry(N);
	overflow <= carry(N) XOR carry(N-1);
end rtl;