Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- SignExtension test bench for the SignExtension IP
--
-- This test bench aims to test the operations of the SignExtension IP
--
-- Written by D. Kokkonis (@kokkonisd)

entity SignExtension_tb is
end entity;


architecture default of SignExtension_tb is
    signal N : integer := 16;
    signal A : std_logic_vector (N - 1 downto 0);
    signal Y : std_logic_vector (31 downto 0);

begin

    -- Test with 32-bit input/output
    T0 : entity work.SignExtension(default) generic map (N) port map (A, Y);

    test : process
    begin
        -- Set A to 12
        A <= X"000C";
        wait for 1 ns;
        -- Check output
        assert Y = X"0000000C" report "Y is wrong for positive input"
                               severity error;

        -- Set A to -12
        A <= X"FFF4";
        wait for 1 ns;
        -- Check output
        assert Y = X"FFFFFFF4" report "Y is wrong for negative input"
                               severity error;
    end process;

end architecture;
