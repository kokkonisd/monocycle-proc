library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Generic MUX for the monocycle MIPS processor
--
-- This unit has 3 inputs and 1 output:
-- A and B are (N-1)-bit data inputs
-- COM is a 1-bit flag input
-- S is an (N-1)-bit data output
-- Also, N is a generic integer input
--
-- It is a standard 2v1 multiplexer, which also
-- has a generic parameter N (corresponding to the input/output size)
--
-- Written by D. Kokkonis (@kokkonisd)

entity MUX is
    generic (
        N : integer range 0 to 32
    );
    port (
        A, B : in std_logic_vector (N - 1 downto 0);
        COM : in std_logic;
        Y : out std_logic_vector (N - 1 downto 0)
    );
end entity;


architecture default of MUX is
begin

    Y <= A when (COM = '0') else B;

end architecture;
