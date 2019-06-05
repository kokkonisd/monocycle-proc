library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Processing unit for the monocycle MIPS processor
--
-- This unit has 7 inputs and 1 output:
-- CLK is the clock line
-- RST is the reset line
-- WE is a write-enable input
-- RA, RB and RW are 3-bit data buses that hold the addresses of A and B
-- and the address on which the data should be written, respectively
-- OP is an operation code in 2 bits
-- N is a 1-bit output flag
--
-- This unit couples the ALU and the register bank together.
-- See files ALU.vhd, RegisterBank.vhd and their test benches for more info.
--
-- Written by D. Kokkonis (@kokkonisd)

entity ProcessingUnit is
    port (
        CLK, RST, WE : in std_logic;
        RA, RB, RW : in std_logic_vector (3 downto 0);
        OP : in std_logic_vector (1 downto 0);
        N : out std_logic
    );
end entity;


architecture default of ProcessingUnit is
    -- A, B and W data buses
    signal A, B, W : std_logic_vector (31 downto 0);

begin

    -- The output of the ALU is connected to the W data bus
    E0 : entity work.ALU(default) port map (OP, A, B, W, N);
    -- The register bank is connected to the ALU via the A, B and W data buses
    E1 : entity work.RegisterBank(default) port map (CLK, RST, W, RA, RB, RW, WE, A, B);

end architecture;
