library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pe_mac is
  generic (
    DATA_WIDTH : integer := 16;
    ACC_WIDTH  : integer := 32;
    PIPELINE_STAGES : integer := 1
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    a_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- element from A
    b_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- element from B
    acc_in: in  std_logic_vector(ACC_WIDTH-1 downto 0);
    acc_out: out std_logic_vector(ACC_WIDTH-1 downto 0)
  );
end entity;


architecture rtl of pe_mac is
  signal a_s, b_s : signed(DATA_WIDTH-1 downto 0);
  signal prod    : signed((DATA_WIDTH*2)-1 downto 0);
  signal acc_reg : signed(ACC_WIDTH-1 downto 0);

  signal prod_reg : signed((DATA_WIDTH*2)-1 downto 0);
  signal add_reg  : signed(ACC_WIDTH-1 downto 0);
begin
  a_s <= signed(a_in);
  b_s <= signed(b_in);

  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        prod_reg <= (others => '0');
        add_reg  <= (others => '0');
        acc_reg  <= (others => '0');
        acc_out  <= (others => '0');
      else
        prod <= a_s * b_s;

        if PIPELINE_STAGES > 0 then
          prod_reg <= prod;

          add_reg <=
            resize(signed(acc_in), ACC_WIDTH) +
            resize(prod_reg,        ACC_WIDTH);

          acc_out <= std_logic_vector(add_reg);
        else
          acc_out <= std_logic_vector(
            resize(signed(acc_in), ACC_WIDTH) +
            resize(prod,           ACC_WIDTH)
          );
        end if;
      end if;
    end if;
  end process;
end architecture;

