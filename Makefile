GO       := GO111MODULE=on go
GOTEST   := CGO_ENABLED=0 $(GO) test -p 1 -v -timeout 6m -race
GOLINT := $(shell command -v golint)

FILES    := $$(find . -name '*.go' -type f -not -name '*.pb.go' -not -name '*_generated.go')

default: fmt vet errcheck test lint

# Taken from https://github.com/codecov/example-go#caveat-multiple-files
.PHONY: test
test:
	echo "mode: atomic" > coverage.txt
	for d in `$(GO) list ./...`; do \
		$(GOTEST) -coverprofile=profile.out -covermode=atomic $$d || exit 1; \
		if [ -f profile.out ]; then \
			tail +2 profile.out >> coverage.txt; \
			rm profile.out; \
		fi \
	done

.PHONY: fmt
fmt:
	gofmt -s -l -w $(FILES)

.PHONY: get
get:
	$(GO) get
	$(GO) mod verify
	$(GO) mod tidy
