library ieee;
use ieee.std_logic_1164.all;

entity fsm_table is
  port (
    clock : in  std_logic;
    reset : in  std_logic;
    w     : in std_logic;
    z     : out std_logic
  );
end fsm_table;

architecture structural of fsm_table is
  type State_type is (A, B, C, D);
  signal y : State_type
begin
  process (clock)
  begin
    if (clock'event and clock = '1') then
      if reset = '1' then 
        y <= A;
      else
        case y is
          when A =>
            if w = '0' then
              y <= C;
            else
              y <= B;
            end if;
          when B =>
            if w = '0' then
              y <= D;
            else
             y <= C;
            end if;
          when C =>
            if w = '0' then
              y <= B;
            end if;
          when D =>
            if w = '0' then
              y <= A;
            else 
              y <= C;
            end if;
        end case;
      end if;
    end if;
  end process;
    
  process (y, w)
  begin
    case y is
      when A =>
        z <= '1';
      when B =>
        z <= not(w);
      when C =>
        z <= '0';
      when D =>
        z <= w;
    end case;
  end process;
end structural;
