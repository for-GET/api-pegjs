define coffee-compile =
	@$(eval input := $<)
	@$(eval output := $@)
	@mkdir -p `dirname $(output)`
	@coffee -pc $(input) > $(output)

COFFEE := $(wildcard *.coffee bin/*.coffee src/**/*.coffee)
JS := $(patsubst src%, lib%, $(COFFEE:.coffee=.js))

$(JS): $(1)

%.js: %.coffee
	$(coffee-compile)

lib/%.js: src/%.coffee
	$(coffee-compile)

.PHONY: all clean prepublish test tap testem

all: $(JS)

clean:
	@rm -f $(JS)

prepublish: clean all

test:
	@mocha --reporter spec test

tap:
	@testem ci

testem:
	@testem
