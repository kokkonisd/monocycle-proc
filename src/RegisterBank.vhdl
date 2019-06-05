library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Register bank for the monocycle MIPS processor
--
-- This unit has 7 inputs and 2 outputs:
-- CLK is the clock line
-- RST is the reset line
-- W is a 32-bit data bus that holds the data to write into register bank
-- RA, RB and RW are 3-bit data buses that hold the addresses of A and B
-- and the address on which the data should be written, respectively
-- WE is a write-enable input
-- A and B are 32-bit data buses that output the content of the registers @RA & @RB
--
-- It performs 2 types of operations:
-- 1. Reading of registers (combinatorial): outputs A and B are set to the values
-- found at the addresses @RA and @RB
-- 2. Writing to registers (synchronous, on rising edge): If WE = 1, then the value
-- of the W bus is written into the register at the address @RW
--
-- Written by D. Kokkonis (@kokkonisd)

entity RegisterBank is
    port (
        CLK, RST : in std_logic;
        W : in std_logic_vector (31 downto 0);
        RA, RB, RW : in std_logic_vector (3 downto 0);
        WE : in std_logic;
        A, B : out std_logic_vector (31 downto 0)
    );
end entity;


architecture default of RegisterBank is
    -- Declaration of type register_array (array of 16 32-bit vectors)
    type register_array is array (15 downto 0) of std_logic_vector (31 downto 0);

    -- Initialization function of register bank
    function init_bank return register_array is
        variable result : register_array;

    begin
        for i in 14 downto 0 loop
            result(i) := (others=>'0');
        end loop;

        -- Put the value 48 (0x30) in the last register, will come handy for testing later
        result(15) := X"00000030";

        return result;
    end function;

    -- Signal containing the register bank
    signal bank : register_array := init_bank;

begin

    write : process (CLK)
    begin
        -- Asynchronous reset
        if RST = '1' then
            bank <= init_bank;
        -- If CLK is on rising edge & WE = 1 write bus W onto register @RW
        elsif rising_edge(CLK) and WE = '1' then
            bank(to_integer(unsigned(RW))) <= W;
        end if;
    end process;

    -- A takes the value of the register at the address @RA
    -- If RA is undefined, A takes the value of the first register
    A <= bank(0) when RA = ("UUUU") or RA = ("XXXX")
                   or RA = ("ZZZZ") or RA = ("WWWW")
                   or RA = ("----") else
         bank(to_integer(unsigned(RA)));
    -- B takes the value of the register at the address @RB
    -- If RB is undefined, B takes the value of the first register
    B <= bank(0) when RB = ("UUUU") or RB = ("XXXX")
                   or RB = ("ZZZZ") or RB = ("WWWW")
                   or RB = ("----") else
         bank(to_integer(unsigned(RB)));

end architecture;
