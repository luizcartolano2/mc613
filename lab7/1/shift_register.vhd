library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
generic (N : integer := 6);
port(
    clk     : in  std_logic;
    mode    : in  std_logic_vector(1 downto 0);
    ser_in  : in  std_logic;
    par_in  : in  std_logic_vector((N - 1) downto 0);
    par_out : out std_logic_vector((N - 1) downto 0)
  );
end shift_register;

architecture rtl of shift_register is
	SIGNAL par_out_buf : STD_LOGIC_VECTOR((N-1) DOWNTO 0);
begin
	PROCESS(clk, mode)
		variable q_out: std_logic_vector((N - 1) downto 0);
	begin
		if clk'event and clk = '1' then
			q_out := par_out_buf;
			if mode = "00" then -- mantem valor
				q_out := q_out;
			elsif mode = "10" then  -- shift_left
				shift_right: for i in 0 to N-2 loop
					q_out(N-i-1) := q_out(N-i-2);
				end loop;
				q_out(0) := ser_in;
			elsif mode = "01" then  -- shift_right
				shift_left: for i in 0 to N-2 loop
					q_out(i) := q_out(i+1);
				end loop;
				q_out(N-1) := ser_in;
			elsif mode = "11" then  -- carga paralela sincrona
				q_out := par_in;
			end if;
		end if;
		if mode = "11" then
			q_out := par_in;
		end if;
		par_out_buf <= q_out;
	end PROCESS;
	par_out <= par_out_buf;
end rtl;
