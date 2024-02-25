
VERSION=$(shell cat VERSION)
NOTARIZATION_PROFILE="App Store Connect - Notarization API Key"

all: adhoc

adhoc:
	xcodebuild -quiet -target qlview-adhoc -configuration Release

release:
	xcodebuild -quiet -target qlview-signed -configuration Release
	codesign --verify --verbose build/Release/qlview

check:

zip:
	rm -rf build/dist
	mkdir -p build/dist
	cp -R build/Release/qlview build/dist
	cp -R mutt build/dist
	cd build/dist && zip -r ../qlview-$(VERSION).zip *
	ls build/*.zip | sed 's/^/> /'

notarize:
	xcrun notarytool submit --keychain-profile $(NOTARIZATION_PROFILE) --wait --timeout 10m build/qlview-$(VERSION).zip

dist: zip notarize

clean:
	rm -rf build
