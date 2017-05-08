SUBDIRS=
FILE_NAME=drivers
export

all: $(SUBDIRS) uart.s
	@echo "Compiling drivers..."
	$(AS) $(ASFLAGS) uart.s -o ../drivers.out

# For each sub directory, call the makefile inside it.
$(SUBDIRS):
	$(MAKE) -C $@

clean:
	#@rm *.out

.PHONY: $(SUBDIRS)
