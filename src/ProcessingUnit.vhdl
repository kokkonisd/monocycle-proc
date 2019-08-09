library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Processing unit for the monocycle MIPS processor
--
-- This unit has 11 inputs and 1 output:
-- CLK is the clock line
-- RST is the reset line
-- COM1 and COM2 are the command signals connected to the two MUXes
-- WER is a write-enable input connected to the register bank
-- WED is a write-enable input connected to the data memory
-- OP is an operation code in 2 bits
-- RA, RB and RW are 3-bit data buses that hold the addresses of A and B
-- and the address on which the data should be written, respectively
-- Imm is the immediate input bus (8 bits)
-- N is a 1-bit output flag
--
-- This unit interconnects the register bank, sign extension unit, 2 MUXes, the
-- ALU and the data memory in order to produce a processing unit.
-- See files RegisterBank.vhdl, SignExtension.vhdl, MUX.vhdl, ALU.vhdl,
-- DataMemory.vhdl and their test benches for more info.
--
-- Written by D. Kokkonis (@kokkonisd)

entity ProcessingUnit is
    port (
        CLK, RST, COM1, COM2, WER, WED : in std_logic;
        OP : in std_logic_vector (1 downto 0);
        RW, RA, RB : in std_logic_vector (3 downto 0);
        Imm : in std_logic_vector (7 downto 0);
        N : out std_logic
    );
end entity;


architecture default of ProcessingUnit is
    -- A, B, W, ALUOut, ImmExt, MUX1 and DMOut data buses
    signal A, B, W, ALUOut, ImmExt, MUX1,
           DMOut: std_logic_vector (31 downto 0);

begin

    -- The register bank is connected to the ALU via the A bus
    -- It's also connected to the first MUX and the data memory via the B bus
    -- Finally, the W bus is also the output of the second MUX (see E5 below)
    E0 : entity work.RegisterBank(default)
         port map (CLK, RST, W, RA, RB, RW, WER, A, B);
    -- The sign extension entity is connected to the first MUX
    E1 : entity work.SignExtension(default)
         generic map (8) port map (Imm, ImmExt);
    -- The first MUX takes in the extended immediate signal and the B bus, and
    -- connects to the second input of the ALU
    E2 : entity work.MUX(default)
         generic map (32) port map (B, ImmExt, COM1, MUX1);
    -- The output of the ALU is connected to the W data bus
    E3 : entity work.ALU(default) port map (OP, A, MUX1, ALUOut, N);
    -- The B bus is connected to the input of the data memory
    -- The address input of the data memory is the last 6 bits of the ALUOut
    -- line
    -- Finally, the output of the data memory is connected to the second MUX
    E4 : entity work.DataMemory(default)
         port map (CLK, RST, B, ALUOut(5 downto 0), WED, DMOut);
    -- The second MUX takes the output of the ALU and output of the data memory
    -- as inputs and connects to the W bus as an output
    E5 : entity work.MUX(default)
         generic map (32) port map (ALUOut, DMOut, COM2, W);


end architecture;
