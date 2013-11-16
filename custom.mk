.PHONY: all

all:
	@rm -f lib/core-precompiled*
	@$(MAKE) -f .coffee.mk/coffee.mk $@
	@echo "Precompiling parsers..."
	@node lib/core-precompiled.js
