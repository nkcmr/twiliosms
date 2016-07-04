.PHONY: binaries release clean

binaries:
	# build release for all platforms
	mkdir -p binaries
	# building binaries for darwin (macOS)
	GOOS=darwin GOARCH=amd64 go build -o ./binaries/twiliosms-darwin-amd64
	GOOS=darwin GOARCH=386 go build -o ./binaries/twiliosms-darwin-386
	# building binaries for linux
	GOOS=linux GOARCH=386 go build -o ./binaries/twiliosms-linux-386
	GOOS=linux GOARCH=amd64 go build -o ./binaries/twiliosms-linux-amd64
	GOOS=linux GOARCH=arm go build -o ./binaries/twiliosms-linux-arm
	GOOS=linux GOARCH=arm64 go build -o ./binaries/twiliosms-linux-arm64
	# building binaries for windows
	GOOS=windows GOARCH=amd64 go build -o ./binaries/twiliosms-windows-amd64.exe
	GOOS=windows GOARCH=386 go build -o ./binaries/twiliosms-windows-386.exe

release:
	mkdir -p release
	tar -cvf ./release/twiliosms-darwin-amd64.tar.gz ./binaries/twiliosms-darwin-amd64
	tar -cvf ./release/twiliosms-darwin-386.tar.gz ./binaries/twiliosms-darwin-386
	tar -cvf ./release/twiliosms-linux-386.tar.gz ./binaries/twiliosms-linux-386
	tar -cvf ./release/twiliosms-linux-amd64.tar.gz ./binaries/twiliosms-linux-amd64
	tar -cvf ./release/twiliosms-linux-arm.tar.gz ./binaries/twiliosms-linux-arm
	tar -cvf ./release/twiliosms-linux-arm64.tar.gz ./binaries/twiliosms-linux-arm64
	tar -cvf ./release/twiliosms-windows-amd64.tar.gz ./binaries/twiliosms-windows-amd64.exe
	tar -cvf ./release/twiliosms-windows-386.tar.gz ./binaries/twiliosms-windows-386.exe

clean:
	rm -rf release
	rm -rf binaries
