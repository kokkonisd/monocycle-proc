Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- ALU test bench for the ALU IP
--
-- This test bench aims to test the operations of the ALU IP
--
-- Written by D. Kokkonis (@kokkonisd)

entity ALU_tb is
end entity;


architecture default of ALU_tb is
    signal OP : std_logic_vector (1 downto 0);
    signal A, B, O : std_logic_vector (31 downto 0);
    signal N : std_logic;

begin

    T0 : entity work.ALU(default) port map (OP, A, B , O, N);

    test : process
    begin
        -- Set A = 5 and B = 7
        A <= X"00000005";
        B <= X"00000007";

        -- Set OP to ADD
        OP <= "00";

        -- Wait till values are stabilized
        wait for 2 ns;
        -- Check A and B values
        assert A = X"00000005" report "A is wrong during ADD (OP = 00)"
                               severity error;
        assert B = X"00000007" report "B is wrong during ADD (OP = 00)"
                               severity error;
        -- Check O value (should be 5 + 7 = 12)
        assert O = X"0000000C" report "O is wrong during ADD (OP = 00)"
                               severity error;
        -- Check N flag (should be 0 because S is not negative)
        assert N = '0' report "N is wrong during ADD (OP = 00)" severity error;

        -- Set OP to PASS B
        OP <= "01";

        -- Wait till values are stabilized
        wait for 2 ns;
        -- Check A and B values
        assert A = X"00000005" report "A is wrong during PASS B (OP = 01)"
                               severity error;
        assert B = X"00000007" report "B is wrong during PASS B (OP = 01)"
                               severity error;
        -- Check O value (should be B = 7)
        assert O = X"00000007" report "O is wrong during PASS B (OP = 01)"
                               severity error;
        -- Check N flag (should be 0 because S is not negative)
        assert N = '0' report "N is wrong during PASS B (OP = 01)"
                       severity error;

        -- Set OP to SUB
        OP <= "10";

        -- Wait till values are stabilized
        wait for 2 ns;
        -- Check A and B values
        assert A = X"00000005" report "A is wrong during SUB (OP = 10)"
                               severity error;
        assert B = X"00000007" report "B is wrong during SUB (OP = 10)"
                               severity error;
        -- Check O value (should be 5 - 7 = -2)
        assert O = X"FFFFFFFE" report "O is wrong during SUB (OP = 10)"
                               severity error;
        -- Check N flag (should be 1 because S is negative)
        assert N = '1' report "N is wrong during SUB (OP = 10)" severity error;

        -- Set OP to PASS A
        OP <= "11";

        -- Wait till values are stabilized
        wait for 2 ns;
        -- Check A and B values
        assert A = X"00000005" report "A is wrong during PASS A (OP = 11)"
                               severity error;
        assert B = X"00000007" report "B is wrong during PASS A (OP = 11)"
                               severity error;
        -- Check O value (should be A = 5)
        assert O = X"00000005" report "O is wrong during PASS A (OP = 11)"
                               severity error;
        -- Check N flag (should be 0 because S is not negative)
        assert N = '0' report "N is wrong during PASS A (OP = 11)"
                       severity error;
    end process;

end architecture;
