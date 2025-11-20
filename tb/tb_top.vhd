library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
end entity;

architecture sim of tb_top is
  constant N          : integer := 4;
  constant DATA_WIDTH : integer := 16;
  constant ACC_WIDTH  : integer := 32;

  -- clock
  constant CLK_PERIOD : time := 10 ns;
  signal clk, rst : std_logic := '0';

  signal a_bus : std_logic_vector(N*DATA_WIDTH-1 downto 0);
  signal b_bus : std_logic_vector(N*DATA_WIDTH-1 downto 0);
  signal c_bus : std_logic_vector(N*ACC_WIDTH-1 downto 0);

begin

  UUT : entity work.top
    generic map (
      N          => N,
      DATA_WIDTH => DATA_WIDTH,
      ACC_WIDTH  => ACC_WIDTH
    )
    port map (
      clk   => clk,
      rst   => rst,
      a_bus => a_bus,
      b_bus => b_bus,
      c_bus => c_bus
    );

  clk_proc : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process;

  stimulus : process
  begin
    -- 1. Reset the system
    rst <= '1';
    wait for 20 ns; -- Hold reset for 2 clock cycles
    rst <= '0';
    wait for CLK_PERIOD; -- Wait one cycle after reset

    -- apply first test vector
    -- a = [5, 4, 3, 2]
    a_bus <= x"0005" & x"0004" & x"0003" & x"0002";
    -- b = [10, 20, 30, 40]
    b_bus <= x"000A" & x"0014" & x"001E" & x"0028";

    wait for 10 * CLK_PERIOD; -- Hold for 10 cycles

    -- apply second test vector
    -- a = [-1, 100, -5, 0]
    a_bus <= x"FFFF" & x"0064" & x"FFFB" & x"0000";
    -- b = [2, -2, 4, 1000]
    b_bus <= x"0002" & x"FFFE" & x"0004" & x"03E8";

    wait for 10 * CLK_PERIOD;

    -- stop simulation
    a_bus <= (others => '0');
    b_bus <= (others => '0');

    -- wait for last output
    wait for 5 * CLK_PERIOD;

    report "Simulation finished successfully." severity note;
    assert false report "STOPPING SIMULATION" severity failure;
  end process;

end architecture;
