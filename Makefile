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

bin/test.system.po: base/prodos.po bin/test.system
	$(CP) base$(SEP)prodos.po bin$(SEP)test.system.po
	java -jar helpers$(SEP)ac.jar -p bin$(SEP)test.system.po test.system sys 0x2000 < bin$(SEP)test.system

bin/test.system: bin/test.system.out
	iix makebin bin$(SEP)test.system.out bin$(SEP)test.system

bin/test.system.out: bin/test.system.o
	iix link bin$(SEP)test.system.o -o bin$(SEP)test.system.out

bin/test.system.o: test.system.asm movecode.macros routines/cleanup.asm
	iix assemble test.system.asm -o bin$(SEP)test.system.o

clean:
	$(RM) bin$(SEP)test.system* bin$(SEP)TEST.SYSTEM*
