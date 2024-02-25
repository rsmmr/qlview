# qlview

This is a standalone document previewer based on macOS's built-in
Quick Look engine——imagine a nicer `qlmanage`. It's particularly
useful as a quick command-line viewer for terminal applications, like
[mutt](http://www.mutt.org).

![Screenshot](screenshot.png "Screenshot")

## Installation

You can either download a [pre-built
release](https://github.com/rsmmr/qlview/releases), or build it
yourself. Either way, you then probably want to copy the executable
into your `PATH`.

When getting the current release, you'll find the executable inside
the ZIP file you downloaded. While it's codesigned and notarized,
please note that you still cannot just double-click to run it, as it
is not an app but a command line application.

When building it yourself, make sure you have Xcode installed. Either
use that to open and build the project, or just run `make` from the
command line. You will then find the executable in
`build/Release/qlview`.

## Usage

Run it from the command line:

```
# qlview <file>
```

If you execute `qlview` without any arguments, it'll open an empty
window where you can drag a document into.

## Mutt integration

To use `qlview` with [mutt](http://www.mutt.org), there's a helper
script
[mutt-qlview](https://github.com/rsmmr/qlview/blob/main/mutt/mutt-qlview)
coming with the distribution. Put both that script and `qlview` itself
into your `PATH` and then add [these mailcap
entries](https://github.com/rsmmr/qlview/blob/main/mutt/mailcap) to
your mutt configuration; see [mutt's
manual](http://www.mutt.org/doc/manual/#mailcap) for more on that.

You can also add the following to your `.muttrc` to quickly open the
first HTML attachment in `qlview`:

```
macro  index,pager V  <view-attachments>/html\n<view-mailcap><quit>
```

## Feedback

Feel free to open issues or pull requests.
