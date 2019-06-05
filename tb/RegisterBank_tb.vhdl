Library ieee;
use ieee.std_logic_1164.all;


-- Register bank test bench for the RegisterBank IP
--
-- This test bench aims to test the reading and writing
-- capabilities of the RegisterBank IP
--
-- Written by D. Kokkonis (@kokkonisd)

entity RegisterBank_tb is
end entity;


architecture default of RegisterBank_tb is
    signal CLK, RST : std_logic;
    signal W : std_logic_vector (31 downto 0);
    signal RA, RB, RW : std_logic_vector (3 downto 0);
    signal WE : std_logic;
    signal A, B : std_logic_vector (31 downto 0);

begin

    T0 : entity work.RegisterBank(default) port map (CLK, RST, W, RA, RB, RW, WE, A, B);

    clk_gen : process
    begin
        CLK <= '1';
        wait for 2 ns;
        CLK <= '0';
        wait for 2 ns;
    end process;


    test : process
    begin
        -- Initialize bank with a reset
        RST <= '1';
        wait for 4 ns;
        RST <= '0';

        -- Read registers @RA = 0 & @RB = 12
        RA <= X"0";
        RB <= X"C";
        -- Wait till values are stabilized
        wait for 1 ns;
        -- Check that we read 0 on both registers
        assert A = X"00000000" report "A is wrong during first read" severity error;
        assert B = X"00000000" report "B is wrong during first read" severity error;

        -- Write into registers @RW = 0 & @RW = 12
        W <= X"0000000A";
        RW <= X"0";
        WE <= '1';
        -- Wait for rising edge to pass
        wait for 4 ns;
        RW <= X"C";
        -- Wait for rising edge to pass
        wait for 4 ns;
        WE <= '0';

        -- Check that we have successfully written on registers
        RA <= X"0";
        RB <= X"C";
        -- Wait till values are stabilized
        wait for 1 ns;
        -- Check that we read 0 on both registers
        assert A = X"0000000A" report "A is wrong during second read" severity error;
        assert B = X"0000000A" report "B is wrong during second read" severity error;
    end process;

end architecture;
