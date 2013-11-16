.PHONY: all clean

all:
	@rm -f lib/core-precompiled*
	@$(MAKE) -f .coffee.mk/coffee.mk $@
	@echo "Precompiling parsers..."
	@node lib/core/index.js

clean:
	@$(MAKE) -f .coffee.mk/coffee.mk $@
	@rm -f lib/core/index.js*