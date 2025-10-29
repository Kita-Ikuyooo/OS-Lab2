C_SRC	= $(sort $(wildcard *.c)) # Get all .c files and sort them
OBJ		= $(patsubst %.c,%.o,$(C_SRC)) # Replace .c with .o files

all:$(OBJ) # Default target to build .o files

# Compile .c to .o
%.o:%.c
	${GCC} ${CFLAG} -c $< 

# Delete all .o files
clean:
	$(shell rm *.o 2>/dev/null)