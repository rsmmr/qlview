// Copyright (c) 2024 by Robin Sommer. See LICENSE for details.

import PDFKit
import SwiftUI
import WebKit

struct Document: Identifiable, Codable, Hashable {
    var url: URL
    let id: Int

    var prettyURL: String {
        if url.isFileURL {
            return url.standardizedFileURL.path
        } else {
            return url.absoluteString
        }
    }

    func open() {
        NSWorkspace.shared.open(url)
    }

    func move() -> Bool {
        let panel = NSSavePanel()
        panel.title = "Move document"
        panel.prompt = "Move"
        panel.message = "Select folder to move document to:"
        panel.canCreateDirectories = true
        panel.showsTagField = false
        panel.nameFieldStringValue = url.lastPathComponent

        if panel.runModal() == .OK {
            if let dst = panel.url {
                do {
                    try FileManager.default.moveItem(at: url, to: dst)
                    return true
                } catch {
                    showAlert(msg: "Error", sub: "Moving failed.", style: .critical)
                }
            }
        }
        return false
    }

    // Printing

    func isHTML() -> Bool {
        return url.pathExtension == "html"
    }

    func isImage() -> Bool {
        return url.pathExtension == "png" || url.pathExtension == "gif" || url.pathExtension == "jpg"
            || url.pathExtension == "jpeg"
    }

    func isMarkdown() -> Bool {
        return url.pathExtension == "md"
    }

    func isPDF() -> Bool {
        return url.pathExtension == "pdf"
    }

    func isTxt() -> NSAttributedString.DocumentType? {
        if url.pathExtension == "txt" {
            return .plain
        }

        if url.pathExtension == "rtf" {
            return .rtf
        }

        return nil
    }

    func canPrint() -> Bool {
        return isPDF() || isMarkdown() || isImage() || isTxt() != nil  // TODO: isHTML() currently no working
    }

    func print() {
        guard canPrint() else { return }

        let info = NSPrintInfo.shared
        let paper_size = NSRect(x: 0, y: 0, width: info.paperSize.width, height: info.paperSize.height)

        info.horizontalPagination = .automatic
        info.verticalPagination = .automatic
        info.verticalPagination = .fit
        info.horizontalPagination = .fit
        info.orientation = .portrait
        info.isHorizontallyCentered = false
        info.isVerticallyCentered = false

        var op: NSPrintOperation?

        if isHTML() {
            // TODO: This doesn't work, printed docoument is always empty.
            // We currently don't get here.
            assert(false)

            // let html = WKWebView(frame: paper_size)
            // html.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            // html.bounds = paper_size
            //
            // // op = html.printOperation(with: printInfo)
            // op = NSPrintOperation(view: html)
        }

        else if isImage() {
            guard let image = NSImage(contentsOf: url) else { return }
            let imageView = NSImageView(image: image)
            imageView.frame = NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            imageView.imageScaling = .scaleProportionallyDown

            info.isHorizontallyCentered = false
            info.isVerticallyCentered = false
            op = NSPrintOperation(view: imageView)
        }

        else if isMarkdown() {
            do {
                let txt = try NSMutableAttributedString(markdown: "Hello, **World**!")

                let view = NSTextView()
                view.frame = paper_size
                view.textStorage?.setAttributedString(txt)
                op = NSPrintOperation(view: view, printInfo: info)
            } catch {
                showAlert(msg: "Printing Error", sub: "Cannot load markdown document.")
            }
        }

        else if isPDF() {
            let pdf = PDFDocument(url: self.url)
            let scale: PDFPrintScalingMode = .pageScaleNone
            op = pdf?.printOperation(for: info, scalingMode: scale, autoRotate: true)
        }

        else if let type = isTxt() {
            do {
                let txt = try NSMutableAttributedString(
                    url: url,
                    options: [
                        .documentType: type,
                        .characterEncoding: String.Encoding.utf8.rawValue,
                        .baseURL: url,  // not really used
                        .readAccessURL: url.deletingLastPathComponent(),  // not really used
                    ], documentAttributes: nil)

                let style = NSMutableParagraphStyle()
                style.lineBreakMode = .byCharWrapping

                txt.setAttributes(
                    [
                        .font: NSFont.monospacedSystemFont(ofSize: 10, weight: .regular),
                        .paragraphStyle: style,
                    ], range: NSMakeRange(0, txt.length))

                let view = NSTextView()
                view.frame = paper_size
                view.textStorage?.setAttributedString(txt)
                op = NSPrintOperation(view: view, printInfo: info)
            } catch {
                showAlert(msg: "Printing Error", sub: "Cannot load text document.")
            }
        }

        if op == nil {
            showAlert(msg: "Print failure", sub: "Cannot print document type")
            return
        }

        op?.jobTitle = url.lastPathComponent
        op?.showsPrintPanel = true
        op?.showsProgressPanel = true

        DispatchQueue.main.async {
            op?.run()
        }
    }
}
