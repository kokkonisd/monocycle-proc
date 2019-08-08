library ieee;
use ieee.std_logic_1164.all;


-- Instruction Management Unit test bench for the IMU IP
--
-- This test bench aims to test the instruction management
-- capabilities of the IMU IP
--
-- Written by D. Kokkonis (@kokkonisd)

entity IMU_tb is
end entity;


architecture default of IMU_tb is
    signal CLK, RST, nPCsel : std_logic;
    signal Offset : std_logic_vector (23 downto 0);
    signal Instruction : std_logic_vector (31 downto 0);

begin

    T0 : entity work.IMU(default)
         port map (CLK, RST, nPCsel, Offset, Instruction);

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

        -- Check that PC increments by itself every clock rising edge
        nPCsel <= '0';
        Offset <= X"00000A";
        wait for 12 ns;

        -- Check that PC increments with Offset every clock rising edge

        nPCsel <= '1';
        wait for 12 ns;

        wait for 2 ns;

    end process;

end architecture;
