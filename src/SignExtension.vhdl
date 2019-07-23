library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Sign extension unit for the monocycle MIPS processor
--
-- This unit has 1 input and 1 output:
-- E is an (N-1)-bit data input
-- S is an 32-bit data output
-- Also, N is a generic integer input
--
-- It expands a smaller input into 32 bits while conserving
-- its sign (negative numbers stay negative).
--
-- Written by D. Kokkonis (@kokkonisd)

entity SignExtension is
    generic (
        N : integer range 0 to 32
    );
    port (
        A : in std_logic_vector (N - 1 downto 0);
        Y : out std_logic_vector (31 downto 0)
    );
end entity;


architecture default of SignExtension is
begin

    Y <= std_logic_vector(resize(signed(A), Y'length));

end architecture;
