COFFEE := $(wildcard src/*.coffee)
JS := $(patsubst src%, lib%, $(COFFEE:.coffee=.js))

.PHONY: all clean prepublish test testem

all: index.js $(JS)

index.js: index.coffee
	@$(eval input := $<)
	@coffee -c $(input)

$(JS): $(1)

lib/%.js: src/%.coffee
	@$(eval input := $<)
	@$(eval output := $@)
	@coffee -pc $(input) > $(output)

clean:
	@rm -f index.js $(JS)

prepublish: clean all

test:
	@mocha --reporter spec test

tap:
	@testem ci

testem:
	@testem
