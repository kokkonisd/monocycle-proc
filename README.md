# Monocycle MIPS Processor

This is based on a university project of the EISE specialty at Polytech Sorbonne (2018-2019). The goal is to build a processor in VHDL capable of executing a subset of the MIPS instruction set. I tried to re-implement it using only [ghdl](http://ghdl.free.fr/) and [gtkwave](http://gtkwave.sourceforge.net/) for testing (and possibly expand it into a multicycle processor). It also serves as a basic demonstration of how to integrate ghdl & gtkwave into a smooth VHDL workflow without using any other IDEs or simulators; I'm programming this processor using only a text editor and a terminal.

---

## Getting started

If you're looking to work/expand on this project or just run it on your machine, here's how you can get started.

### Installing ghdl
According to their [site](http://ghdl.free.fr/site/pmwiki.php?n=Main.Download) this was supposed to be easy, but the package doesn't exist in the `apt` database (or at least I couldn't find it), so the next easiest/most reliable thing is to build it from source. You have to install [GNAT](http://libre2.adacore.com/) if you don't have it, and then you can just clone their [github repo](https://github.com/ghdl/ghdl) and build normally:

```
$ ./configure
$ make
$ make install
```

**Note**: (In Ubuntu,) I needed to use `sudo` in order to install it, but it somehow couldn't find `gnatmake` when I did that. My solution was to edit both the `configure` file and the `Makefile` of the ghdl repo clone and give them the absolute path for `gnatmake` (in my case it was `/opt/GNAT/2019/bin/gnatmake`). I also have this whole setup on my Mac and I could just build from source without any problems.

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

Coming soon!
