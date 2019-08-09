# Monocycle MIPS Processor

This is based on a university project of the EISE specialty at Polytech
Sorbonne (2018-2019). The goal is to build a processor in VHDL capable of
executing a subset of the MIPS instruction set. I tried to re-implement it
using only [ghdl](http://ghdl.free.fr/) and
[gtkwave](http://gtkwave.sourceforge.net/) for testing (and possibly expand it
into a multicycle processor). It also serves as a basic demonstration of how to
integrate ghdl & gtkwave into a smooth VHDL workflow without using any other
IDEs or simulators; I'm programming this processor using only a text editor and
a terminal.

---

## Getting started

If you're looking to work/expand on this project or just run it on your
machine, here's how you can get started.

### Installing ghdl
According to their [site](http://ghdl.free.fr/site/pmwiki.php?n=Main.Download)
this was supposed to be easy, but the package doesn't exist in the `apt`
database (or at least I couldn't find it), so the next easiest/most reliable
thing is to build it from source. You have to install
[GNAT](http://libre2.adacore.com/) if you don't have it, and then you can just
clone their [github repo](https://github.com/ghdl/ghdl) and build normally:

```
$ ./configure
$ make
$ make install
```

**Note**: (In Ubuntu,) I needed to use `sudo` in order to install it, but it
somehow couldn't find `gnatmake` when I did that. My solution was to edit both
the `configure` file and the `Makefile` of the ghdl repo clone and give them
the absolute path for `gnatmake` (in my case it was
`/opt/GNAT/2019/bin/gnatmake`). I also have this whole setup on my Mac and I
could just build from source without any problems.

### Installing gtkwave
This is pretty easy. You can just fetch it via `apt`:

```
$ sudo apt-get install gtkwave
```

And on Mac you can fetch it through [Homebrew](https://brew.sh/):

```
$ brew install gtkwave
```

---

## Processor architecture

_[The architecture is incomplete. I'm still writing the docs and coding the_
_IPs.]_

Table of contents

- [ALU](#alu)
- [Register bank](#register-bank)
- [MUX 2v1](#mux-2v1)
- [Sign extension](#sign-extension)
- [Data memory](#data-memory)
- [Processing Unit](#processing-unit)
- [Instruction memory](#instruction-memory)
- [IMU](#imu)


### ALU

The ALU (Arithmetic and Logic Unit) takes care of performing basic mathematical
operations:

![ALU](arch_diagrams/ALU.svg)

Based on the value of `OP`, the operations it performs have as follows:

| OP  | O     |
| :-: | :---: |
| 00  | A + B |
| 01  | B     |
| 10  | A - B |
| 11  | A     |


### Register bank

The register bank contains the CPU's 16 32-bit registers.

![Register bank](arch_diagrams/RegisterBank.svg)

#### Read
The read operations are asynchronous; outputs `A` and `B` contain the values
found at the addresses `RA` and `RB` respectively. When `RA` and/or `RB` are
undefined, `A` and/or `B` output the value of the register at address `0`.

#### Write
The write operations are synchronous, and are performed on the clock's rising
edge. On rising edge, if `WE = 1` and `RW` is not undefined, the value of the
`W` bus is written onto the register at address `RW`.

The `RST` is asynchronous.


### MUX 2v1

This is a simple 2v1 multiplexer with variable input/output length (its maximum
length is 32 bits).

![MUX 2v1](arch_diagrams/MUX-2v1.svg)

Here are the outputs based on `COM`'s value:

| COM  | Y   |
| :--: | :-: |
| 0    | A   |
| 1    | B   |


### Sign extension

This is a simple one input, one output block that converts an N-bit input into
a 32-bit output, while keeping the same sign (+/-).

![Sign extension](arch_diagrams/SignExtension.svg)

Of course, here `N <= 32`.


### Data memory

This is a data memory containing a storage space of 64 32-bit words. Its
architecture is not that different from that of the
[register bank](#register-bank):

![Data memory](arch_diagrams/DataMemory.svg)

#### Read
The read operation is asynchronous; `DataOut` contains the value of the word at
address `Addr`, or the word at address `0` if `Addr` is undefined.

#### Write
The write operation is synchronous, and is performed on the clock's rising
edge. On rising edge, if `WE = 1` and `Addr` is defined, then the 32-bit word
in `DataIn` is stored at address `Addr` in the memory.


### Processing Unit

This is the assembled Processing Unit. It contains an [ALU](#alu), a
[register bank](#register-bank), two [MUXes](#mux-2v1), a
[sign extension entity](#sign-extension) and a [data memory](#data-memory).

![Processing Unit (detailed)](arch_diagrams/ProcessingUnit_detailed.svg)

This unit allows us to perform all the basic operations, given a data memory.
Here is a top-level diagram of the Processing Unit entity:

![Processing Unit (top-level)](arch_diagrams/ProcessingUnit.svg)

#### Operations

This unit can perform the following operations:

1. Move values from the data memory into registers
2. Move values from registers into the data memory
3. Add/subtract with registers and store the result in another register
4. Add/subtract with registers and store the result in the data memory
5. Add/subtract with a register and an immediate value (8 bits) and store the
result in another register
6. Add/subtract with a register and an immediate value (8 bits) and store
the result in the data memory


#### Detailed connections

##### Register bank
The `A` output of the register bank is connected to the `A` input
of the ALU.

The `B` output of the register bank is connected to the `A` input of the first
MUX, and also to the `DataIn` input of the data memory.

The `W` bus is connected to the output of the second MUX.

The inputs `CLK`, `RST`, `WE`, `RW`, `RA` and `RB` are not connected and are
thus considered inputs to the PU entity.

##### Sign extension
The input of the sign extension is an 8-bit immediate input. It is converted
to a 32-bit vector in the output, while keeping the same sign; it is then
connected to the `B` input of the first MUX.

##### First MUX
The `A` input of the first MUX is connected to the `B` output of the register
bank. The `B` input is connected to the output of the sign extension entity.

The `Y` output is connected to the `B` input of the ALU. The `COM` input is not
connected and is thus considered an input to the PU entity.

##### ALU
The `A` input of the ALU is connected to the `A` output of the register bank.
The `B` input is connected to the `Y` output of the first MUX.

The `O` output is connected to the `A` input of the second MUX; its 6 least
significant bits are connected to the `Addr` input of the data memory.

The `OP` input and `N` output are not connected and are thus considered
inputs/outputs to the PU entity.

##### Data memory
The `DataIn` input is connected to the `B` output of the register bank. The
`DataOut` output is connected to the `B` input of the second MUX. The `Addr`
input is connected to the 6 least significant bits of the `O` output
of the ALU.

The inputs `CLK`, `RST` and `WE` are not connected and are thus considered
inputs to the PU entity.

##### Second MUX
The `A` input is connected to the `O` output of the ALU. The `B` input is
connected to the `DataOut` output of the data memory. The `Y` output is
connected to the `W` input of the register bank.

The `COM` input is not connected and is thus considered an input to the PU
entity.


### Instruction memory

The instruction memory is similar to the [data memory](#data-memory):

![Instruction memory](arch_diagrams/InstructionMemory.svg)

It contains a set of MIPS instructions -- which, in this case, is hardcoded
into the memory -- and, given an address (refered to as `PC` in this case, as
in _Program Counter_), it outputs the instruction that is found at that
address.


### IMU

The IMU (Instruction Management Unit) handles the processing of the
instructions.

![IMU](arch_diagrams/IMU.svg)

It contains the [instruction memory](#instruction-memory), the
`PC` register (that contains the address of the next instruction to be read),
a [sign extension](#sign-extension) entity that can convert an address offset
coded on 24 bits to a 32-bit address. Finally, a [MUX](#mux-2v1) determines
if the instruction is a _normal_ instruction or if it is a _jump_ instruction:

- If `nPCsel = 0`, the instruction is a normal one, so `PC` is simply
  incremented (`PC = PC + 1`)
- If `nPCsel = 1`, the instruction is a jump, so `PC` is incremented by 1 and
  also by the 32-bit address that results from the 24-bit offset
  (`PC = PC + 1 + SignExtension(Offset)`).
