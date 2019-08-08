library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Instruction memory test bench for the InstructionMemory IP
--
-- This test bench aims to test the reading
-- capabilities of the InstructionMemory IP
--
-- Written by D. Kokkonis (@kokkonisd)

entity InstructionMemory_tb is
end entity;


architecture default of InstructionMemory_tb is
    signal CLK, RST : std_logic;
    signal PC, Instruction : std_logic_vector (31 downto 0);

begin

    T0 : entity work.InstructionMemory(default)
         port map (CLK, RST, PC, Instruction);

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

        -- Read the memory line by line and make sure the program is OK
        PC <= X"00000000";
        wait for 4 ns;
        assert Instruction = X"E3A01020" report "Instruction memory is wrong" &
                                                "@0x0"
                                         severity error;

        PC <= std_logic_vector(unsigned(PC) + 1);
        wait for 4 ns;
        assert Instruction = X"E3A02000" report "Instruction memory is wrong" &
                                                "@0x1"
                                         severity error;

        PC <= std_logic_vector(unsigned(PC) + 1);
        wait for 4 ns;
        assert Instruction = X"E6110000" report "Instruction memory is wrong" &
                                                "@0x2"
                                         severity error;

        PC <= std_logic_vector(unsigned(PC) + 1);
        wait for 4 ns;
        assert Instruction = X"E0822000" report "Instruction memory is wrong" &
                                                "@0x3"
                                         severity error;

        PC <= std_logic_vector(unsigned(PC) + 1);
        wait for 4 ns;
        assert Instruction = X"E2811001" report "Instruction memory is wrong" &
                                                "@0x4"
                                         severity error;

        PC <= std_logic_vector(unsigned(PC) + 1);
        wait for 4 ns;
        assert Instruction = X"E351002A" report "Instruction memory is wrong" &
                                                "@0x5"
                                         severity error;

        PC <= std_logic_vector(unsigned(PC) + 1);
        wait for 4 ns;
        assert Instruction = X"BAFFFFFB" report "Instruction memory is wrong" &
                                                "@0x6"
                                         severity error;

        PC <= std_logic_vector(unsigned(PC) + 1);
        wait for 4 ns;
        assert Instruction = X"E6012000" report "Instruction memory is wrong" &
                                                "@0x7"
                                         severity error;

        PC <= std_logic_vector(unsigned(PC) + 1);
        wait for 4 ns;
        assert Instruction = X"EAFFFFF7" report "Instruction memory is wrong" &
                                                "@0x8"
                                         severity error;

        wait for 2 ns;

    end process;

end architecture;
