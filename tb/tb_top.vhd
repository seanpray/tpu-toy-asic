library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
end entity;

architecture sim of tb_top is
  constant CLK_PERIOD : time := 10 ns;
  signal clk, rst : std_logic := '0';
  -- instantiate small 4x4 array for quick sim
  signal a_bus : std_logic_vector(4*16-1 downto 0);
  signal b_bus : std_logic_vector(4*16-1 downto 0);
  signal c_bus : std_logic_vector(4*32-1 downto 0);
begin
  clk_proc : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process;

  stimulus : process
  begin
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    -- load small test matrices into memories or drive inputs
    -- Example: set a_bus and b_bus with known values
    a_bus <= (others => '0'); -- pack 4 16-bit numbers here
    b_bus <= (others => '0');
    wait for 500 ns;
    -- check outputs (use assertions or write to file)
    wait;
  end process;

  -- instantiate pe_array with N=>4
end architecture;

