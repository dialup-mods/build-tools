# must be this way to work on bash and win shells
LOCALAPPDATA    := $(shell powershell -NoProfile -Command "[Environment]::GetFolderPath('LocalApplicationData')")

DIALUP_ROOT     := $(LOCALAPPDATA)/DialUp

BUILD_TOOLS_DIR := $(DIALUP_ROOT)/build-tools
EXCEPTION_FILE  := $(BUILD_TOOLS_DIR)/shell-exception.txt

VCVARS          := C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Auxiliary\\Build\\vcvars64.bat
               
GENERATOR       := Ninja
MAKEFLAGS       += --no-print-directory
INJECTOR        := $(LOCALAPPDATA)/DialUp/bin/DialUpInjector.exe

define run_with_vcvars
	cmd /C "$(VCVARS)" & $(1)
endef

PROBABLYMICROSOFT := 1
ifeq ($(strip $(MSYSTEM)),)
	PROBABLYMICROSOFT := 0
endif

check-shell:
	@if [ "$(PROBABLYMICROSOFT)" = "1" ]; then \
		cat "$(EXCEPTION_FILE)"; \
		exit 1; \
	fi

install-with-prompt:
	@echo "Install to $(DIALUP_ROOT)?"
	@attempts=0; \
	chat_wow() { \
		echo "Wow!"; \
		sleep 0.3; \
		}; \
	chat_wow_okay() { \
		echo "Wow!"; \
		sleep 0.3; \
		echo "Okay!"; \
		sleep 0.3; \
		}; \
	chat_noooo() { \
		echo "Noooo!"; \
		sleep 0.3; \
		}; \
	chat_gg() { \
		echo "gg"; \
		sleep 0.6; \
		echo "Faking."; \
		sleep 0.3; \
		}; \
	chats=( \
		chat_wow \
		chat_wow_okay \
		chat_noooo \
		chat_gg \
	); \
	while true; do \
		attempts=$$((attempts + 1)); \
		if [ "$$attempts" -gt 1 ]; then \
			read -p "You have time! Continue? [Y/n] " ans; \
		else \
			read -p "Continue? [Y/n] " ans; \
		fi; \
		case "$$ans" in \
			""|[Yy]|[Yy][Ee][Ss]|[Yy][Ee][Ss]\!) \
				echo "Proceeding..."; \
				break ;; \
			[Nn]|[Nn][Oo]) \
				if [ "$$attempts" -gt 3 ]; then \
					echo "No problem."; \
					sleep 0.3; \
					exit 1; \
				fi; \
				selectedChat=$${chats[$$RANDOM % $${#chats[@]}]}; \
				"$$selectedChat" \
				exit 1 ;; \
			*) \
				echo "Please answer yes or no." ;; \
		esac; \
	done
	@$(MAKE) install-impl
