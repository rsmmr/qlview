
all: adhoc

adhoc:
	xcodebuild -quiet -target qlview-adhoc

signed:
	xcodebuild -quiet -target qlview-signed
