.PHONY: binaries release clean

release:
	mkdir -p release
	gox $(VERSION_FLAGS) -output="release/{{.Dir}}_{{.OS}}_{{.Arch}}"

clean:
	rm -rf release

VERSION          := $(shell git describe --tags --always --dirty="-dev")
DATE             := $(shell date -u '+%Y-%m-%d-%H%M UTC')
VERSION_FLAGS    := -ldflags='-X "main.Version=$(VERSION)" -X "main.BuildTime=$(DATE)"'
