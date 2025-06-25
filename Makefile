.PHONY: all validate

all: validate

validate:
	jq --compact-output '.' templates.json 1>/dev/null || exit 1
	check-jsonschema --schemafile schema.json templates.json || exit 1
