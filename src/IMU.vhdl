library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Instruction Management Unit for the monocycle MIPS processor
--
-- This unit has 4 inputs and 1 output:
-- CLK is the clock line
-- RST is the reset line
-- nPCsel is a MUX control signal on 1 bit
-- Offset is a PC jump offset on 24 bits
-- Instruction is a 32-bit instruction code
--
-- This unit updates the PC (Program Counter) and fetches
-- the next instruction from the instruction memory.
--
-- Written by D. Kokkonis (@kokkonisd)

entity IMU is
    port (
        CLK, RST, nPCsel : in std_logic;
        Offset : in std_logic_vector (23 downto 0);
        Instruction : out std_logic_vector (31 downto 0)
    );
end entity;


architecture default of IMU is

    signal ExtendedOffset, PC : std_logic_vector (31 downto 0);
    constant OffsetSize : integer := 24;

begin

    -- Extend 24-bit offset to 32-bit
    Ext : entity work.SignExtension(default) generic map (OffsetSize) port map (Offset, ExtendedOffset);

    cycle : process (CLK, RST)
    begin
        -- Asynchronous reset
        if RST = '1' then
            PC <= (others => '0');
        -- If CLK is on rising edge
        elsif rising_edge(CLK) then
            -- If nPCsel = 0, just increment PC
            if nPCsel = '0' then
                PC <= std_logic_vector(unsigned(PC) + 1);
            -- If nPCsel = 1, increment PC and add offset
            else
                PC <= std_logic_vector(unsigned(PC) + 1 + unsigned(ExtendedOffset));
            end if;
        end if;
    end process;

    -- Branch PC into the instruction memory and fetch the instruction
    Mem : entity work.InstructionMemory(default) port map (CLK, RST, PC, Instruction);

end architecture;
