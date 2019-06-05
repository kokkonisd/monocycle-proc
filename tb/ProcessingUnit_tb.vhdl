library ieee;
use ieee.std_logic_1164.all;


-- Processing unit test bench for the ProcessingUnit IP
--
-- This test bench aims to test the operations of the ProcessingUnit IP
--
-- Written by D. Kokkonis (@kokkonisd)

entity ProcessingUnit_tb is
end entity;


architecture default of ProcessingUnit_tb is
    signal CLK, RST, WE : std_logic;
    signal RA, RB, RW : std_logic_vector (3 downto 0);
    signal OP : std_logic_vector (1 downto 0);
    signal N : std_logic;

begin

    T0 : entity work.ProcessingUnit(default) port map (CLK, RST, WE, RA, RB, RW, OP, N);

    clk_gen : process
    begin
        CLK <= '1';
        wait for 2 ns;
        CLK <= '0';
        wait for 2 ns;
    end process;


    test : process
    begin
        assert RST = '1' report "Note: you should check the chronogram of this test to verify it" severity note;
        -- Initialize unit with a reset
        RST <= '1';
        wait for 4 ns;
        RST <= '0';

        -- Perform a bunch of operations

        -- R(1) = R(15)
        RA <= X"F";
        OP <= "11";
        RW <= X"1";
        WE <= '1';
        -- Wait till value is written
        wait for 6 ns;
        WE <= '0';
        -- 'Show' R(1)
        RB <= X"1";
        OP <= "01";
        wait for 4 ns;

        -- R(1) = R(1) + R(15)
        RA <= X"1";
        RB <= X"F";
        OP <= "00";
        RW <= X"1";
        WE <= '1';
        -- Wait till value is written
        wait for 6 ns;
        WE <= '0';
        -- 'Show' R(1)
        RB <= X"1";
        OP <= "01";
        wait for 4 ns;

        -- R(2) = R(1) + R(15)
        RA <= X"1";
        RB <= X"F";
        OP <= "00";
        RW <= X"2";
        WE <= '1';
        -- Wait till value is written
        wait for 6 ns;
        WE <= '0';
        -- 'Show' R(2)
        RB <= X"2";
        OP <= "01";
        wait for 4 ns;

        -- R(3) = R(1) - R(15)
        RA <= X"1";
        RB <= X"F";
        OP <= "10";
        RW <= X"3";
        WE <= '1';
        -- Wait till value is written
        wait for 6 ns;
        WE <= '0';
        -- 'Show' R(3)
        RB <= X"3";
        OP <= "01";
        wait for 4 ns;

        -- R(5) = R(7) - R(15)
        RA <= X"7";
        RB <= X"F";
        OP <= "10";
        RW <= X"5";
        WE <= '1';
        -- Wait till value is written
        wait for 6 ns;
        WE <= '0';
        -- 'Show' R(5)
        RB <= X"5";
        OP <= "01";
        wait for 4 ns;
    end process;

end architecture;
