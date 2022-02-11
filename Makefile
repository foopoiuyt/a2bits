bin/test.system.po: base/prodos.po bin/test.system
	copy base\prodos.po bin\test.system.po
        java -jar helpers\ac.jar -p bin\test.system.po test.system sys 0x2000 < bin\test.system

bin/test.system: bin/test.system.out
	iix makebin bin/test.system.out bin/test.system

bin/test.system.out: bin/test.system.o
	iix link bin/test.system.o -o bin/test.system.out

bin/test.system.o: test.system.asm movecode.macros routines/cleanup.asm
	iix assemble test.system.asm -o bin/test.system.o

clean:
	del bin\test.system.*
