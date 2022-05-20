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

default: bin/screen.system.po

bin/screen.system.po: base/prodos.po bin/screen.system bin/screen.bin
	$(CP) base$(SEP)prodos.po bin$(SEP)screen.system.po
	java -jar helpers$(SEP)ac.jar -p bin$(SEP)screen.system.po screen.system sys 0x2000 < bin$(SEP)screen.system
	java -jar helpers$(SEP)ac.jar -p bin$(SEP)screen.system.po screen bin 0x0800 < bin$(SEP)screen.bin

bin/screen.system: bin/screen.system.out
	iix makebin bin$(SEP)screen.system.out bin$(SEP)screen.system

bin/screen.system.out: bin/base.system.o bin/screen.loader.o
	iix link bin$(SEP)base.system.o bin$(SEP)screen.loader.o -o bin$(SEP)screen.system.out

bin/base.system.o: base.system.asm routines/cleanup.asm routines/waitforkey.macros routines/setupgraphics.asm constants/prodos.asm constants/switches.asm constants/zp.asm
	iix assemble base.system.asm -o bin$(SEP)base.system.o

bin/screen.bin: bin/screen.out
	iix makebin bin$(SEP)screen.out bin$(SEP)screen.bin

bin/screen.out: bin/screen.o
	iix link bin$(SEP)screen.o -o bin$(SEP)screen.out

bin/screen.o: app/screen.asm routines/cleanup.asm routines/waitforkey.macros routines/setupgraphics.asm routines/screen.asm constants/prodos.asm constants/switches.asm constants/zp.asm
	iix assemble app/screen.asm -o bin$(SEP)screen.o

bin/screen.loader.o: app/screen.loader.asm
	iix assemble app/screen.loader.asm -o bin$(SEP)screen.loader.o

clean:
	$(RM) bin$(SEP)base.system* bin$(SEP)BASE.SYSTEM*
	$(RM) bin$(SEP)screen* bin$(SEP)SCREEN*
