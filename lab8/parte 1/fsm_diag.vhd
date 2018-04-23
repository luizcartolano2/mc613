library ieee;
use ieee.std_logic_1164.all;

entity fsm_diag is
  port (
    clock : in  std_logic;
    reset : in  std_logic;
    w     : in  std_logic;
    z     : out std_logic
  );
end fsm_diag;

architecture structural of fsm_diag is
  type State_type is (A, B, C, D);
  signal y : State_type;
begin
  process (clock)
  begin
    if (clock'event and clock = '1') then
      if reset = '1' then
        y <= A;
      else
        case y is
          when A =>
            if w = '1' then
              y <= B;
            end if;
          when B =>
            if w = '0' then
              y <= C;
            end if;
          when C =>
            if w = '1' then
              y <= D;
            end if;
          when D =>
            if w = '0' then
              y <= A;
            end if;
        end case;
      end if;
    end if;
  end process;
  
  z <= '1' when y = B else '0';
end structural;
