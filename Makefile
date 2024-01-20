
all: debug

debug:
	@xcodebuild -quiet -target qlview-adhoc -configuration Debug

release:
	@xcodebuild -quiet -target qlview-signed -configuration Release

check:
	codesign --verify --verbose build/Release/qlview
	codesign --display --verbose=4 build/Release/qlview 2>&1 | grep Signed
