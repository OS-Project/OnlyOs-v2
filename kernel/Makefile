SUBDIRS = boot interrupt
FILE_NAME = kernel
export

all: $(SUBDIRS) kernel.c
	@echo "Compiling kernel..."
	$(CC) $(CFLAGS) kernel.c -o kernel.out
	$(AR) r ../kernel.out interrupt.out boot.out kernel.out

# For each sub directory, call the makefile inside it.
$(SUBDIRS):
	$(MAKE) -C $@

clean:
	@rm *.out

.PHONY: $(SUBDIRS)
