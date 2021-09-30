SRCDIR=src
HEADDIR=include
LIBDIR=build
BINDIR=tool
EXEC=nxtirf

CC :=g++
GCC:=gcc

CCFLAGS_MAIN := -pipe -std=c++0x -O3    -Wall -Wextra -fopenmp $(COMPTIMEPLACE) $(OPTIMFLAGS) $(OPTIMFLAGS1)
CCFLAGS_GDB := -pipe  -std=c++0x -g -O0 -Wall -Wextra -fopenmp $(COMPTIMEPLACE)
COMPTIMEPLACE := -D'COMPILATION_TIME_PLACE="$(shell echo `date` `hostname --fqdn`:`pwd`)"'

LDFLAGS := -lz
LDFLAGS_static := -static-libgcc -static-libstdc++ -lz

LDFLAGS_GDB :=
OPTIMFLAGS :=
OPTIMFLAGS1 :=
# below flags make little difference.
#OPTIMFLAGS=-ffast-math
#OPTIMFLAGS=-fforce-addr -funsafe-loop-optimizations -ftree-loop-linear -ftree-vectorize 
#OPTIMFLAGS=-fforce-addr -funsafe-loop-optimizations -ftree-vectorize 
# unroll-loops slows the program ~6%.
#OPTIMFLAGS1=-funroll-loops  -fprefetch-loop-arrays

BIN=NxtIRFStatic
SRC:=$(wildcard $(SRCDIR)/*.cpp)
SRC:=$(filter-out $(SRCDIR)/RcppExports.cpp, $(SRC))
TMP=$(subst $(SRCDIR),$(LIBDIR), $(SRC))
OBJ=$(patsubst %.cpp,%.o,$(TMP))

all: $(BIN)

NxtIRF : CCFLAGS=$(CCFLAGS_MAIN)
NxtIRF: $(OBJ)
	@[ ! -d $(BINDIR) ] & mkdir -p $(BINDIR)
	$(CC) -o $(BINDIR)/$(EXEC) $(CCFLAGS) $(OBJ) $(LDFLAGS)

NxtIRFStatic : CCFLAGS=$(CCFLAGS_MAIN)
NxtIRFStatic: $(OBJ)
	@[ ! -d $(BINDIR) ] & mkdir -p $(BINDIR)
	$(CC) -o $(BINDIR)/$(EXEC) $(CCFLAGS) $(OBJ) $(LDFLAGS_static)

gdb : CCFLAGS=$(CCFLAGS_GDB)
gdb : $(OBJ)
	@[ ! -d $(BINDIR) ] & mkdir -p $(BINDIR)
	$(CC) -o $(BINDIR)/$(EXEC) $(CCFLAGS_GDB) $(OBJ) $(LDFLAGS_GDB) 

$(LIBDIR)/%.o: $(SRCDIR)/%.cpp  
	@[ ! -d $(dir $@) ] & mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(CCFLAGS)

.PHONY = clean  

%.o : %.cpp
	$(CC) -c $(CCFLAGS) $<

all: NxtIRFStatic

clean :
	rm -rf $(BINDIR)/$(EXEC)
	rm -rf $(LIBDIR)/*.o

