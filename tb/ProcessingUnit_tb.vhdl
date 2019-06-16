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
    signal CLK, RST, COM1, COM2, WER, WED : std_logic;
    signal OP : std_logic_vector (1 downto 0);
    signal RW, RA, RB : std_logic_vector (3 downto 0);
    signal Imm : std_logic_vector (7 downto 0);
    signal N : std_logic;

begin

    T0 : entity work.ProcessingUnit(default) port map (CLK, RST, COM1, COM2, WER, WED, OP, RW, RA, RB, Imm, N);

    clk_gen : process
    begin
        CLK <= '1';
        wait for 2 ns;
        CLK <= '0';
        wait for 2 ns;
    end process;


    test : process
    begin
        -- Initialize unit with a reset
        RST <= '1';
        wait for 4 ns;
        RST <= '0';

        -- Perform a bunch of operations

        -- Add two registers together
        RA <= X"F";
        RB <= X"0";
        COM1 <= '0';
        OP <= "00";
        COM2 <= '0';

        wait for 1 ns;
        -- Check N
        assert N = '0' report "N is wrong after adding two positive or null registers together" severity error;

        RW <= X"0";
        WER <= '1';
        wait for 4 ns;
        WER <= '0';
        wait for 1 ns;

        -- ====

        -- Add a register and an immediate value together
        RA <= X"F";
        Imm <= X"05";
        COM1 <= '1';
        OP <= "00";
        COM2 <= '0';

        wait for 1 ns;
        -- Check N
        assert N = '0' report "N is wrong after adding a positive or null register and an immediate value together" severity error;

        RW <= X"1";
        WER <= '1';
        wait for 4 ns;
        WER <= '0';
        wait for 1 ns;

        -- ====

        -- Subtract a register from another register
        RA <= X"0";
        RB <= X"1";
        COM1 <= '0';
        OP <= "10";
        COM2 <= '0';

        wait for 1 ns;
        -- Check N
        assert N = '1' report "N is wrong after substraction of registers" severity error;

        RW <= X"2";
        WER <= '1';
        wait for 4 ns;
        WER <= '0';
        wait for 1 ns;

        -- ====

        -- Subtract an immediate value from a register
        RA <= X"F";
        Imm <= X"08";
        COM1 <= '1';
        OP <= "10";
        COM2 <= '0';

        wait for 1 ns;
        -- Check N
        assert N = '0' report "N is wrong after subtracting an immediate value from a register" severity error;

        RW <= X"3";
        WER <= '1';
        wait for 4 ns;
        WER <= '0';
        wait for 1 ns;

        -- ====

        -- Copy the value of a register into another register
        RA <= X"2";
        OP <= "11";
        COM2 <= '0';

        wait for 1 ns;
        -- Check N
        assert N = '1' report "N is wrong after moving a register value" severity error;

        RW <= X"4";
        WER <= '1';
        wait for 4 ns;
        WER <= '0';
        wait for 1 ns;

        -- ====

        -- Write a register into data memory
        RB <= X"4";
        RA <= X"A";
        OP <= "11";

        wait for 1 ns;
        -- Check N
        assert N = '0' report "N is wrong after moving a register value into data memory" severity error;

        WED <= '1';
        wait for 4 ns;
        WED <= '0';
        wait for 1 ns;

        -- ====

        -- Copy a memory word into a register
        RA <= X"A";
        OP <= "11";
        COM2 <= '1';

        wait for 1 ns;

        RW <= X"5";
        WER <= '1';
        wait for 4 ns;
        WER <= '0';
        wait for 1 ns;

    end process;

end architecture;
