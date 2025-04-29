.PHONY: all validate

all: validate

validate:
	check-jsonschema --schemafile schema.json templates.json
