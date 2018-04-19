library ieee;
use ieee.std_logic_1164.all;

entity shift_register_out is
generic (N : integer := 6);
port(
    KEY  : in  std_logic_vector(0 downto 0);
    SW   : in  std_logic_vector(8 downto 0);
    LEDR : out std_logic_vector((N - 1) downto 0)
  );
end shift_register_out;

architecture rtl of shift_register_out is
	SIGNAL par_out_buf : STD_LOGIC_VECTOR((N-1) DOWNTO 0);
begin
	PROCESS(KEY(0), SW(8 DOWNTO 7))
		variable q_out: std_logic_vector((N - 1) downto 0);
	begin
		if KEY(0)'event and KEY(0) = '0' then
			q_out := par_out_buf;
			if SW(8 DOWNTO 7) = "00" then -- mantem valor
				q_out := q_out;
			elsif SW(8 DOWNTO 7) = "01" then  -- shift_left
				shift_right: for i in 0 to N-2 loop
					q_out(N-i-1) := q_out(N-i-2);
				end loop;
				q_out(0) := SW(6);
			elsif SW(8 DOWNTO 7) = "10" then  -- shift_right
				shift_left: for i in 0 to N-2 loop
					q_out(i) := q_out(i+1);
				end loop;
				q_out(N-1) := SW(6);
			elsif SW(8 DOWNTO 7) = "11" then  -- carga paralela sincrona
				q_out := SW(5 DOWNTO 0);
			end if;
		end if;
		par_out_buf <= q_out;
	end PROCESS;
	LEDR <= par_out_buf;
end rtl;