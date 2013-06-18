# Default
.PHONY: all

all: force
	@$(MAKE) -f .coffee.mk/coffee.mk $@

%: force
	@$(MAKE) -f .coffee.mk/coffee.mk $@

force: ;

# Custom
