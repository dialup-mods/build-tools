PROBABLYMICROSOFT := 1
ifeq ($(strip $(MSYSTEM)),)
	PROBABLYMICROSOFT := 0
endif

check-shell:
	@if [ "$(PROBABLYMICROSOFT)" = "1" ]; then \
		cat "$(EXCEPTION_FILE)"; \
		exit 1; \
	fi
