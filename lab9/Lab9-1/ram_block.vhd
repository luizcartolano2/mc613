library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_block is
  port (
    Clock : in std_logic;
    Address : in std_logic_vector(6 downto 0);
    Data : in std_logic_vector(7 downto 0);
    Q : out std_logic_vector(7 downto 0);
    WrEn : in std_logic
  );
end ram_block;

architecture direct of ram_block is
  type matriz2d is array (0 to 127) of std_logic_vector(7 downto 0);
  signal ram : matriz2d;
begin
  process (Clock, WrEn, Address) 
  begin
    if Clock'event and Clock = '1' then
      if WrEn = '1' then
        ram(to_integer(unsigned(Address))) <= Data;
      end if;
    end if;
    if WrEn = '0' then
      Q <= ram(to_integer(unsigned(Address)));
    end if;
  end process;
end direct;
