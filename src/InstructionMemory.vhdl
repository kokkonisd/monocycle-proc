library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Instruction Memory for the monocycle MIPS processor
--
-- This unit has 3 inputs and 1 output:
-- CLK is the clock line
-- RST is the reset line
-- PC is an address input in 32-bits
-- Instruction is a 32-bit instruction code
--
-- This unit fetches the instruction found at address
-- @PC in the instruction memory.
--
-- Written by D. Kokkonis (@kokkonisd)

entity InstructionMemory is
    port (
        CLK, RST : in std_logic;
        PC : in std_logic_vector (31 downto 0);
        Instruction : out std_logic_vector (31 downto 0)
    );
end entity;


architecture default of InstructionMemory is
    -- Declaration of 64 32-bit word RAM type
    type RAM64x32 is array (0 to 63) of std_logic_vector (31 downto 0);

    -- Declaration of RAM initialization function
    function init_mem return RAM64x32 is
        variable result : RAM64x32;

    begin
        -- Initialize everything at 0
        for i in 63 downto 0 loop
            result(i) := (others => '0');
        end loop;

        -- Hardcode a simple program into memory
        result(0) := X"E3A01020";  -- 0x0 _main   -- MOV R1,#0x20    -- R1 = 0x20
		result(1) := X"E3A02000";  -- 0x1		 -- MOV R2,#0x00    -- R2 = 0
		result(2) := X"E6110000";  -- 0x2 _loop   -- LDR R0,0(R1)    -- R0 = DATAMEM[R1]
		result(3) := X"E0822000";  -- 0x3		 -- ADD R2,R2,R0    -- R2 = R2 + R0
		result(4) := X"E2811001";  -- 0x4		 -- ADD R1,R1,#1    -- R1 = R1 + 1
		result(5) := X"E351002A";  -- 0x5		 -- CMP R1,0x2A     -- si R1 >= 0x2A
		result(6) := X"BAFFFFFB";  -- 0x6		 -- BLT loop 	    -- PC = PC + (-5) si N = 1
		result(7) := X"E6012000";  -- 0x7		 -- STR R2,0(R1)    -- DATAMEM[R1] = R2
		result(8) := X"EAFFFFF7";  -- 0x8		 -- BAL main	    -- PC = PC + (-7)

        return result;
    end function;

    signal Memory : RAM64x32 := init_mem;

begin

    read : process (CLK, RST)
    begin
        -- Asynchronous reset
        if RST = '1' then
            Memory <= init_mem;
        elsif rising_edge(CLK) then
            -- If PC is undefined, data is not read
            if PC /= ("UUUU") and PC /= ("XXXX") and PC /= ("ZZZZ")
                              and PC /= ("WWWW") and PC /= ("----") then
                Instruction <= Memory(to_integer(unsigned(PC)));
            end if;
        end if;
    end process;

end architecture;
