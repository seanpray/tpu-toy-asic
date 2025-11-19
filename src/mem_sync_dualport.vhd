library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_sync_dualport is
  generic (
    ADDR_WIDTH : integer := 8; -- 2^8 = 256 words
    DATA_WIDTH : integer := 16
  );
  port (
    clk   : in  std_logic;
    we_a  : in  std_logic;
    addr_a: in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    din_a : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    dout_a: out std_logic_vector(DATA_WIDTH-1 downto 0);

    we_b  : in  std_logic;
    addr_b: in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    din_b : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    dout_b: out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of mem_sync_dualport is
  type ram_t is array(natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal ram : ram_t(0 to (2**ADDR_WIDTH)-1);
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if we_a = '1' then
        ram(to_integer(unsigned(addr_a))) <= din_a;
      end if;
      dout_a <= ram(to_integer(unsigned(addr_a)));

      if we_b = '1' then
        ram(to_integer(unsigned(addr_b))) <= din_b;
      end if;
      dout_b <= ram(to_integer(unsigned(addr_b)));
    end if;
  end process;
end architecture;

