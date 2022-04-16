all: default

ifdef MAKEDIR:
!ifdef MAKEDIR
CP = copy
RM = del
SEP = \\
!else
else
CP = cp
RM = rm -f
SEP = /
endif
!endif :

default: bin/test.system.po

bin/test.system.po: base/prodos.po bin/test.system bin/screen.bin
	$(CP) base$(SEP)prodos.po bin$(SEP)test.system.po
	java -jar helpers$(SEP)ac.jar -p bin$(SEP)test.system.po test.system sys 0x2000 < bin$(SEP)test.system
	java -jar helpers$(SEP)ac.jar -p bin$(SEP)test.system.po screen bin 0x0800 < bin$(SEP)screen.bin

bin/test.system: bin/test.system.out
	iix makebin bin$(SEP)test.system.out bin$(SEP)test.system

bin/test.system.out: bin/test.system.o
	iix link bin$(SEP)test.system.o -o bin$(SEP)test.system.out

bin/test.system.o: test.system.asm routines/cleanup.asm routines/waitforkey.macros routines/setupgraphics.asm constants/prodos.asm constants/switches.asm constants/zp.asm
	iix assemble test.system.asm -o bin$(SEP)test.system.o

bin/screen.bin: bin/screen.out
	iix makebin bin$(SEP)screen.out bin$(SEP)screen.bin

bin/screen.out: bin/screen.o
	iix link bin$(SEP)screen.o -o bin$(SEP)screen.out

bin/screen.o: app/screen.asm routines/cleanup.asm routines/waitforkey.macros routines/setupgraphics.asm routines/screen.asm constants/prodos.asm constants/switches.asm constants/zp.asm
	iix assemble app/screen.asm -o bin$(SEP)screen.o

clean:
	$(RM) bin$(SEP)test.system* bin$(SEP)TEST.SYSTEM*
