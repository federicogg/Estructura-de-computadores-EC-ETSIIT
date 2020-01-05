##########################################################################
SKP = (hola64-c.s printf32.s printf32e.s printf64.s)

A32 = $(filter-out $(SKP), $(wildcard *32*.s))
S32 = $(filter-out $(SKP), $(wildcard *32*.c *32*.cc))
O32 = $(A32:.s=.o)
E32 = $(basename $(A32) $(S32))

A64 = $(filter-out $(SKP), $(wildcard *64*.s))
S64 = $(filter-out $(SKP), $(wildcard *64*.c *64*.cc))
O64 = $(A64:.s=.o)
E64 = $(basename $(A64) $(S64))

ASM = $(filter-out $(A32) $(A64), $(wildcard *.s))
SRC = $(wildcard *.c *.cc)
OBJ = $(O32) $(O64)
EXE = $(E32) $(E64) $(basename $(ASM)) $(basename $(SRC))
ATT = $(EXE:=.att)
##########################################################################
CFLAGS = -g -std=c11 -Wall
CXXFLAGS = $(CFLAGS:c11=c++11)
##########################################################################
all: $(EXE) $(ATT)

clean:
	-rm -fv $(ATT) $(EXE) $(OBJ) *~

.PHONY: all clean
##########################################################################
$(O32): ASFLAGS=--32 -g -nostartfiles
$(E32): LDFLAGS=-dynamic-linker -L/usr/lib -lc -melf_i386
$(O64): ASFLAGS=--64 -g -nostartfiles
$(E64): LDFLAGS=-dynamic-linker --no-add-needed -L/usr/lib64 -lc -melf_x86_64

addable: CXXFLAGS+=-fconcepts -std=c++14
sum0: CXXFLAGS+=-O0
sum1: CXXFLAGS+=-O1
sum2: CXXFLAGS+=-O2
sum3: CXXFLAGS+=-O3
sums: CXXFLAGS+=-Os
##########################################################################
%: %.o
	$(LD) $(LDFLAGS) $< -o $@

%: %.s
	$(CC) $(CFLAGS) -nostartfiles $< -o $@

%: %.c
	$(CC) $(CFLAGS) $< -o $@

%: %.cc
	$(CXX) $(CXXFLAGS) $< -o $@

%.att: %
	objdump -C -d $< > $@
##########################################################################
