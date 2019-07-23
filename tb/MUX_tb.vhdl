Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- MUX test bench for the MUX IP
--
-- This test bench aims to test the operations of the MUX IP
--
-- Written by D. Kokkonis (@kokkonisd)

entity MUX_tb is
end entity;


architecture default of MUX_tb is
    signal N : integer := 32;
    signal A, B : std_logic_vector (N - 1 downto 0);
    signal COM : std_logic;
    signal Y : std_logic_vector (N - 1 downto 0);

begin

    -- Test with 32-bit input/output
    T0 : entity work.MUX(default) generic map (N) port map (A, B, COM, Y);

    test : process
    begin
        -- Assign two random values to A and B
        A <= X"FFFFFFFE";
        B <= X"0000000C";

        -- Check that Y is A when COM is 0
        COM <= '0';
        wait for 1 ns;
        assert Y = A report "Y is wrong when COM is 0" severity error;

        -- Check that Y is B when COM is 1
        COM <= '1';
        wait for 1 ns;
        assert Y = B report "Y is wrong when COM is 1" severity error;
    end process;
end architecture;
