Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity alu_tb is
end entity;


architecture default of alu_tb is
    signal OP1 : std_logic_vector (1 downto 0);
    signal A, B, S : std_logic_vector (31 downto 0);
    signal N : std_logic;

begin

    T0 : entity work.ALU(default) port map (OP1, A, B , S, N);

    test : process
    begin

        A <= X"00000005";
        B <= X"00000007";

        OP1 <= "00"; -- ADD

        wait for 2 ns;
        assert A = X"00000005" report "A is wrong during ADD (OP = 00)" severity error;
        assert B = X"00000007" report "B is wrong during ADD (OP = 00)" severity error;
        assert S = X"0000000C" report "S is wrong during ADD (OP = 00)" severity error;
        wait for 2 ns;

        OP1 <= "01"; -- PASS B

        wait for 2 ns;
        assert A = X"00000005" report "A is wrong during PASS B (OP = 01)" severity error;
        assert B = X"00000007" report "B is wrong during PASS B (OP = 01)" severity error;
        assert S = X"00000007" report "S is wrong during PASS B (OP = 01)" severity error;
        wait for 2 ns;

        OP1 <= "10"; -- SUB

        wait for 2 ns;
        assert A = X"00000005" report "A is wrong during SUB (OP = 10)" severity error;
        assert B = X"00000007" report "B is wrong during SUB (OP = 10)" severity error;
        assert S = X"FFFFFFFE" report "S is wrong during SUB (OP = 10)" severity error;
        wait for 2 ns;

        OP1 <= "11"; -- PASS A

        wait for 2 ns;
        assert A = X"00000005" report "A is wrong during PASS A (OP = 11)" severity error;
        assert B = X"00000007" report "B is wrong during PASS A (OP = 11)" severity error;
        assert S = X"00000005" report "S is wrong during PASS A (OP = 11)" severity error;
        wait for 2 ns;

    end process;

end architecture;
