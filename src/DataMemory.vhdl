library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Data memory for the monocycle MIPS processor
--
-- This unit has 4 inputs and 1 output:
-- CLK is the clock line
-- RST is the reset line
-- DataIn is a 32-bit data bus that holds the data to write into register
-- memory
-- Addr is a 6-bit data bus that holds the address on which the data should be
-- read or written
-- WE is a write-enable input
-- DataOut is a 32-bit data bus that outputs the content of the memory @Addr
--
-- This unit allows storage of up to 64 32-byte words.
-- The reading of data is combinatorial, while the writing
-- is synchronous (on rising edge of clock).
--
-- Written by D. Kokkonis (@kokkonisd)

entity DataMemory is
    port (
        CLK, RST : in std_logic;
        DataIn : in std_logic_vector (31 downto 0);
        Addr : in std_logic_vector (5 downto 0);
        WE : in std_logic;
        DataOut : out std_logic_vector (31 downto 0)
    );
end entity;


architecture default of DataMemory is
    -- Declaration of type data_array (array of 16 32-bit vectors)
    type data_array is array (63 downto 0) of std_logic_vector (31 downto 0);

    -- Initialization function of data memory array
    function init_memory return data_array is
        variable result : data_array;

    begin
        for i in 63 downto 0 loop
            result(i) := (others => '0');
        end loop;

        return result;
    end function;

    -- Signal containing the data memory
    signal memory : data_array := init_memory;

begin

    write : process (CLK, RST)
    begin
        -- Asynchronous reset
        if RST = '1' then
            memory <= init_memory;
        -- If CLK is on rising edge & WE = 1 write bus W onto register @Addr
        elsif rising_edge(CLK) and WE = '1' then
            -- If Addr is undefined, data is not written
            if Addr /= ("UUUUUU") and Addr /= ("XXXXXX") and Addr /= ("ZZZZZZ")
                                  and Addr /= ("WWWWWW") and Addr /= ("------")
                                  then
                memory(to_integer(unsigned(Addr))) <= DataIn;
            end if;
        end if;
    end process;

    -- DataOut takes the value of the memory at the address @Addr
    -- If Addr is undefined, DataOut takes the value of the first register
    DataOut <= memory(0) when Addr = ("UUUUUU") or Addr = ("XXXXXX")
                           or Addr = ("ZZZZZZ") or Addr = ("WWWWWW")
                           or Addr = ("------") else
               memory(to_integer(unsigned(Addr)));

end architecture;
