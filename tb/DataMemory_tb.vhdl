Library ieee;
use ieee.std_logic_1164.all;


-- Data memory test bench for the DataMemory IP
--
-- This test bench aims to test the reading and writing
-- capabilities of the DataMemory IP
--
-- Written by D. Kokkonis (@kokkonisd)

entity DataMemory_tb is
end entity;


architecture default of DataMemory_tb is
    signal CLK, RST : std_logic;
    signal DataIn : std_logic_vector (31 downto 0);
    signal Addr : std_logic_vector (5 downto 0);
    signal WE : std_logic;
    signal DataOut : std_logic_vector (31 downto 0);

begin

    T0 : entity work.DataMemory(default) port map (CLK, RST, DataIn, Addr, WE, DataOut);

    clk_gen : process
    begin
        CLK <= '1';
        wait for 2 ns;
        CLK <= '0';
        wait for 2 ns;
    end process;


    test : process
    begin
        -- Initialize memory with a reset
        RST <= '1';
        wait for 4 ns;
        RST <= '0';

        -- Read memory address @Addr = 0
        Addr <= (others => '0');
        -- Wait till values are stabilized
        wait for 5 ns;
        -- Check that we read 0 on memory address @Addr = 0
        assert DataOut = X"00000000" report "DataOut is wrong during first read" severity error;

        -- Write into memory address @Addr = 12
        DataIn <= X"0000000A";
        Addr <= "001100";
        WE <= '1';
        -- Wait for rising edge to pass
        wait for 5 ns;
        WE <= '0';

        -- Check that we have successfully written on memory address
        Addr <= "001100";
        -- Wait till values are stabilized
        wait for 5 ns;
        -- Check that we read 0xA on memory address @Addr = 12
        assert DataOut = X"0000000A" report "DataOut is wrong during second read" severity error;

        wait for 5 ns;
    end process;

end architecture;
