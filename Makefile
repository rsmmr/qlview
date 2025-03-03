
VERSION=$(shell cat VERSION)
NOTARIZATION_PROFILE="App Store Connect - Notarization API Key"
CODESIGN_IDENTITY="Developer ID Application: Robin Sommer (4UJK727T59)"

DMG="build/qlview-$(VERSION).dmg"

all: build

build:
	xcodebuild -quiet -target qlview -configuration Release

dmg:
	rm -f $(DMG)
	rm -rf build/dist
	mkdir -p build/dist
	cp -a build/Release/qlview.app build/dist
	cp -a mutt build/dist
	cp -a resources/DS_Store build/dist/.DS_Store
	ln -s /Applications/ build/dist/Applications
	codesign -f --timestamp -o runtime -s $(CODESIGN_IDENTITY) build/dist/qlview.app
	hdiutil create -volname "qlview $(VERSION)" -srcFolder build/dist -o $(DMG)
	codesign --timestamp -s $(CODESIGN_IDENTITY) $(DMG)
	codesign --verify --verbose $(DMG)

notarize:
	xcrun notarytool submit --keychain-profile $(NOTARIZATION_PROFILE) --wait --timeout 10m $(DMG)
	xcrun stapler staple $(DMG)

check:
	@echo
	syspolicy_check distribution $(DMG)

dist: build dmg notarize check
	@echo
	ls build/*.dmg | sed 's/^/> /'

clean:
	rm -rf build

icons:
	# github.com:abeintopalo/AppIconSetGen.git
	appiconsetgen resources/icon.png --output qlview/Assets.xcassets --macOS
