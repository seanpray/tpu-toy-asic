library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pe_array is
  generic (
    N : integer := 16;
    DATA_WIDTH : integer := 16;
    ACC_WIDTH  : integer := 32
  );
  port (
    clk  : in std_logic;
    rst  : in std_logic;
    -- inputs: flattened arrays or busses; for clarity we use 2D mapped to 1D
    a_in  : in  std_logic_vector(N*DATA_WIDTH-1 downto 0); -- row inputs
    b_in  : in  std_logic_vector(N*DATA_WIDTH-1 downto 0); -- col inputs
    c_out : out std_logic_vector(N*ACC_WIDTH-1 downto 0)    -- outputs per row
  );
end entity;

architecture rtl of pe_array is
  -- helper functions to slice vectors would be convenient; for brevity inline indexes
  component pe_mac
    generic ( DATA_WIDTH: integer; ACC_WIDTH: integer );
    port ( clk, rst: in std_logic;
           a_in, b_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
           acc_in: in std_logic_vector(ACC_WIDTH-1 downto 0);
           acc_out: out std_logic_vector(ACC_WIDTH-1 downto 0) );
  end component;

  type acc_array is array(0 to N-1) of std_logic_vector(ACC_WIDTH-1 downto 0);
  signal accs : acc_array;
begin
  pe_gen : for i in 0 to N-1 generate
    -- simple mapping: each PE takes a_in[i], b_in[i] and accumulates into accs[i].
    pe_inst : pe_mac
      generic map ( DATA_WIDTH => DATA_WIDTH, ACC_WIDTH => ACC_WIDTH )
      port map (
        clk => clk,
        rst => rst,
        a_in => a_in((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH),
        b_in => b_in((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH),
        acc_in => (others => '0'), -- connect partial sums or previous PE in real design
        acc_out => accs(i)
      );
    c_out((i+1)*ACC_WIDTH-1 downto i*ACC_WIDTH) <= accs(i);
  end generate;
end architecture;

