#yuawn

ALL				= main

all: $(ALL)
	@echo "${GREEN}Make Success${NC}\n$(YELLOW)main()${NC}"

CC        	= g++
EngineInc	= -I./engine/include
EngineLib	= -L./engine/lib
LIB			= -lOpenGL -lGLEW -lGLFW -lMao
CFLAGS		= -w -std=c++11
LDFLAGS		= -Wl,-no_pie,-e,_Yuawn

NASM 		= ./engine/nasm-2.14rc0/nasm
YASM		= ./engine/yasm-1.2.0/yasm
ASMFLAGS2 	= -f macho64 --prefix _
ASMFLAGS	= -f macho64 -w --prefix=_

#$(foreach i,$(YUAWN2),./equipment/$(i))

YUAWN		= main Enemy Object Weapon
PPAP		= $(foreach i,$(YUAWN),./singularity/group_35_$(i))
ASM 		= $(foreach i,$(PPAP),$(i).asm)
OO	        = $(foreach i,$(PPAP),$(i).o)

Cyan		= \033[0;36m
GREEN		= \033[0;32m
YELLOW		= \033[1;33m
RED       	= \033[0;31m
NC         	= \033[0m



$(ALL):$(OO)
	@$(CC) $(OO) $(CFLAGS) $(LDFLAGS) $(EngineLib) $(LIB) -o $(ALL)
	@echo "CC $(OO)"
	@rm -f $(OO)
	@echo "Clean OO"

$(OO):$(ASM)
	@$(foreach i,$(PPAP),$(NASM) $(ASMFLAGS2) -o $(i).o $(i).asm;)
	@echo "NASM $(ASM)"

clean:
	@rm -f $(ALL) $(OO)
	@echo "${Cyan}Clean Up...${NC}"
