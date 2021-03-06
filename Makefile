DROPLAN_VERSION ?= latest

test:
	go test . -cover

build:
	go build .

build-amd64:
	@docker run -it --rm -v `pwd`:/go/src/github.com/tam7t/droplan -w /go/src/github.com/tam7t/droplan golang:alpine env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-X main.appVersion=${DROPLAN_VERSION}" -o droplan

build-i386:
	@docker run -it --rm -v `pwd`:/go/src/github.com/tam7t/droplan -w /go/src/github.com/tam7t/droplan golang:alpine env GOOS=linux GOARCH=386 CGO_ENABLED=0 go build -ldflags="-X main.appVersion=${DROPLAN_VERSION}" -o droplan_i386

release: build-amd64 build-i386
	@zip droplan_${DROPLAN_VERSION}_linux_amd64.zip droplan
	@tar -cvzf droplan_${DROPLAN_VERSION}_linux_amd64.tar.gz droplan
	@rm droplan

	@mv droplan_i386 droplan
	@zip droplan_${DROPLAN_VERSION}_linux_386.zip droplan
	@tar -cvzf droplan_${DROPLAN_VERSION}_linux_386.tar.gz droplan
	@rm droplan

docker: build-amd64 docker-image clean

docker-image:
	@docker build -t tam7t/droplan:${DROPLAN_VERSION} .

clean:
	@rm -f droplan
	@rm -rf droplan_*.zip
	@rm -rf droplan_*.tar.gz
