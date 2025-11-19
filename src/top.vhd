library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  generic (
    N          : integer := 4;   -- For testing; change to 16 later
    DATA_WIDTH : integer := 16;
    ACC_WIDTH  : integer := 32
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;

    -- Flattened row inputs of matrix A (N elements × DATA_WIDTH)
    a_bus : in  std_logic_vector(N*DATA_WIDTH-1 downto 0);

    -- Flattened column inputs of matrix B (N elements × DATA_WIDTH)
    b_bus : in  std_logic_vector(N*DATA_WIDTH-1 downto 0);

    -- Output accumulators from each PE
    c_bus : out std_logic_vector(N*ACC_WIDTH-1 downto 0)
  );
end entity top;

architecture rtl of top is

  component pe_array
    generic (
      N          : integer;
      DATA_WIDTH : integer;
      ACC_WIDTH  : integer
    );
    port (
      clk   : in  std_logic;
      rst   : in  std_logic;
      a_in  : in  std_logic_vector(N*DATA_WIDTH-1 downto 0);
      b_in  : in  std_logic_vector(N*DATA_WIDTH-1 downto 0);
      c_out : out std_logic_vector(N*ACC_WIDTH-1 downto 0)
    );
  end component;

begin

  pe_arr_inst : pe_array
    generic map(
      N          => N,
      DATA_WIDTH => DATA_WIDTH,
      ACC_WIDTH  => ACC_WIDTH
    )
    port map(
      clk   => clk,
      rst   => rst,
      a_in  => a_bus,
      b_in  => b_bus,
      c_out => c_bus
    );

end architecture rtl;

