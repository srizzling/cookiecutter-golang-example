GO_FILES := $(find . -iname '*.go' -type f | grep -v /vendor/)
BINARY=mygolangproject
BUILD_DIR := build
GOARCH = amd64

TEST_REPORT      = $(BUILD_DIR)/tests.xml
COVERAGE_DIR 	 = $(BUILD_DIR)/coverage
COVERAGE_MODE    = atomic
COVERAGE_PROFILE = $(COVERAGE_DIR)/profile.out
COVERAGE_XML     = $(COVERAGE_DIR)/coverage.xml
COVERAGE_HTML    = $(COVERAGE_DIR)/index.html

VERSION := $(shell git describe --tags --always --dirty --match=v* 2> /dev/null || echo v0)
COMMIT=$(shell git rev-parse HEAD)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS = -ldflags "-X main.Version=$(VERSION) -X main.COMMIT=${COMMIT} -X main.BRANCH=${BRANCH} -X main.BinaryName=${BINARY}"

all: deps lint build test

clean:
	@rm -rf $(BUILD_DIR)/*

linux:
	GOOS=linux GOARCH=${GOARCH} go build ${LDFLAGS} -o $(BUILD_DIR)/${BINARY}-linux-${GOARCH}

darwin:
	GOOS=darwin GOARCH=${GOARCH} go build ${LDFLAGS} -o $(BUILD_DIR)/${BINARY}-darwin-${GOARCH}

windows:
	GOOS=windows GOARCH=${GOARCH} go build ${LDFLAGS} -o $(BUILD_DIR)/${BINARY}-windows-${GOARCH}

build-all: linux darwin windows

build: clean vendor
	@mkdir -p build && go build -o build/$(BINARY)

run: build
	./build/$(BINARY)

lint:
	@docker run --rm -v $(pwd):/app -w /app golangci/golangci-lint:v1.35.2 golangci-lint run

.PHONY: test
test:
	@go test -mod vendor -v -race ./...

format:
	@gofmt -l -s ./...

.PHONY: coverage
coverage:
	@mkdir -p $(COVERAGE_DIR)
	@go test -v -race $(GO_FILES) -coverprofile $(COVERAGE_PROFILE) -covermode=$(COVERAGE_MODE) ./...
	go tool cover -html=$(COVERAGE_PROFILE) -o $(COVERAGE_HTML)

.PHONY: vendor
vendor: ## Updates the vendoring directory.
	@$(RM) go.sum
	@$(RM) -r vendor
	GO111MODULE=on go mod init || true
	GO111MODULE=on go mod tidy
	GO111MODULE=on go mod vendor

## TODO(): prepare-release - https://github.com/momocow/semantic-release-gitmoji
#prepare-release:

