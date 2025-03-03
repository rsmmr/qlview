# qlview

This is a standalone document previewer based on macOS's built-in
Quick Look engine——imagine a nicer `qlmanage`. It's particularly
useful for using from the command line or inside terminal
applications, like [mutt](http://www.mutt.org).

![Screenshot](screenshot.png "Screenshot")

## Installation

You can either download a [pre-built
release](https://github.com/rsmmr/qlview/releases), or build it
yourself.

When getting the current release, install it like any other
application: open the disk image and drag the app to your
`Applications` folder.

When building it yourself, make sure you have Xcode installed. Either
use that to open and build the project, or just run `make` from the
command line. You will then find the application in
`build/Release/qlview.app`.

## Usage

You can start `qlview` from the Finder, and it'll open an empty window
where you can drag a document into. More usefully, you can open
documents from the command line through a custom URL scheme:

```
# open qlview:/path/to/file
```

## Mutt integration

To use `qlview` with [mutt](http://www.mutt.org), there's a helper
script
[mutt-qlview](https://github.com/rsmmr/qlview/blob/main/mutt/mutt-qlview)
coming with the distribution. Put that script into your `PATH` and
then add [these mailcap
entries](https://github.com/rsmmr/qlview/blob/main/mutt/mailcap) to
your mutt configuration. See [mutt's
manual](http://www.mutt.org/doc/manual/#mailcap) for more on that.

You can also add the following to your `.muttrc` to quickly open the
first HTML attachment in `qlview`:

```
macro  index,pager V  <view-attachments>/html\n<view-mailcap><quit>
```

## Feedback

Feel free to open issues or pull requests.
