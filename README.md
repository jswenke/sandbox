# sandbox

## Version info.
VIVADO_VER : 2019.1

VERSION_REG: 0x00010001

DATE_REG   : 0x01262025

## Build instructions
WIP

## Notes
1/20/25: Make scripts dir and .tcl/.sh's for making/building project next

1/22/25: Update scripts to include synth/impl and contraints stuff, then add git guide or something

1/26/25: Start looking into tying UART together with async fifo, writing the fifo, etc.
Also look into adding a build ID functionality/register to keep track of builds when running/testing multiple

1/27/25: 
http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
Was reading this paper on async FIFO design, planning to follow some of the design recommendations and implement an async FIFO to test the UART RX/TX with

1/28/25:
Started barebones async fifo, wrote out some signals, types, etc. Read a bit more of the sunburst paper.

