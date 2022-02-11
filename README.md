# a2bits
Some random bits playing with apple2 

# Requirements

## Building the applications

Assembling the code currently expects an ORCA/M 2.0 and GoldenGate installation and the Makefile is currently made for building on Windows.

ORCA/M https://juiced.gs/store/opus-ii-software/
GoldenGate https://juiced.gs/store/golden-gate/

## Build the disk image

The makefile expects base disk images in the `base` directory, currently a prodos.po with PRODOS (and optionally BASIC.SYSTEM) included.

And, it expects a copy of AppleCommander as ac.jar in the `helpers` directory.
