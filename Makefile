
VERSION=$(shell cat VERSION)

all: adhoc

adhoc:
	@xcodebuild -quiet -target qlview-adhoc -configuration Release

release:
	@xcodebuild -quiet -target qlview-signed -configuration Release

check: release
	codesign --verify --verbose build/Release/qlview
	spctl --assess --verbose build/Release/qlview

dist: release
	@rm -rf build/dist
	@mkdir -p build/dist
	cp -R build/Release/qlview build/dist
	cd build/dist && zip -r ../qlview-$(VERSION).zip *
	@ls build/*.zip
