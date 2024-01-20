// Copyright (c) 2024 by Robin Sommer. See LICENSE for details.

import AppKit
import Quartz
import SwiftUI

class OurQuickLookItem: NSObject, QLPreviewItem {
    var previewItemURL: URL!
    var previewItemTitle: String?
}

struct QLView: NSViewRepresentable {
    let url: URL?

    func makeNSView(context: Context) -> NSView {
        let view = QLPreviewView()

        if let url = url {
            let item = OurQuickLookItem()
            item.previewItemURL = url
            item.previewItemTitle = "Preview"
            view.previewItem = item
        }

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
    }
}

struct ContentView: View {
    @State var doc: Document?
    @State var window: NSWindow? = nil

    @Namespace private var Namespace
    @FocusState private var focus: Bool
    @Environment(\.dismiss) private var dismiss

    func saveWindowSize() {
        guard let window = window else { return }

        // window.saveFrame(usingName: "MyWindowSize") // does not seem to do anything

        // To see the value recorded here, use "defaults read qlview". To flush
        // the state, "defaults delete qlview".
        UserDefaults.standard.set(window.frameDescriptor, forKey: "MyWindowSize")
    }

    func restoreWindowSize() {
        guard let window = window else { return }

        // window.setFrameUsingName("MyWindowSize") // same as above

        if let frame = UserDefaults.standard.string(forKey: "MyWindowSize") {
            window.setFrame(from: frame)
        }
    }

    var body: some View {
        VStack {
            if let doc = doc {
                QLView(url: doc.url)
                    .focused($focus)

                Text(doc.prettyURL)
                    .monospaced()
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .focusable(false)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background()
            } else {
                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        ContentUnavailableView {
                            Label("No document.", systemImage: "tray.fill")
                        } description: {
                            Text("Drag a file here.")
                        }

                        Spacer()
                    }
                    Spacer()
                }
                .onDrop(of: [.url], isTargeted: nil) { providers in
                    providers.first?.loadDataRepresentation(
                        forTypeIdentifier: "public.file-url",
                        completionHandler: { (data, error) in
                            if let data = data, let path = NSString(data: data, encoding: 4),
                                let url = URL(string: path as String)
                            {
                                self.doc = Document(url: url, id: 42)
                            }
                        })
                    return self.doc != nil
                }
            }
        }
        .toolbar {
            if let doc = doc {
                ToolbarItemGroup(placement: .automatic) {

                    Button(action: { doc.print() }) {
                        Image(systemName: "printer")
                    }
                    .disabled(!doc.canPrint())
                    .help("Print")

                    ShareLink(item: doc.url)
                        .help("Share ...")
                }

                ToolbarItemGroup(placement: .automatic) {
                    Spacer()
                }

                ToolbarItemGroup(placement: .automatic) {
                    Button(action: {
                        if doc.move() {
                            dismiss()
                        }
                    }) {
                        Text("Move")
                    }.help("Move to ...")

                    Button(action: {
                        doc.open()
                        dismiss()
                    }) {
                        Text("Open")
                    }
                    .help("Open")
                }
            }
        }
        .onAppear { focus = true }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeMainNotification)) { notification in
            if window == nil {
                if let win = notification.object as? NSWindow {
                    window = win
                    restoreWindowSize()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { notification in
            saveWindowSize()
        }
        .onCopyCommand {
            guard let doc = doc else { return [] }
            guard let provider = NSItemProvider(contentsOf: doc.url) else { return [] }
            return [provider]
        }
    }
}

// Preview only works with 'productType = "com.apple.product-type.application"' in 'project.pbxproj'.
// That however then builds an Application instead of a command line tool. For the latter, we need
// 'productType = "com.apple.product-type.tool". So we need to switch between the two by directly
// editing that file.

// #Preview("Preview") {
//    ContentView(doc: Document(url: URL(fileURLWithPath: "/Users/robin/Data/www-icir/tmp/brotagonist.jpg"), id: 1))
//}

//#Preview("Empty") {
//    ContentView(doc: nil)
//}
