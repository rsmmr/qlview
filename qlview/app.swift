import SwiftUI

extension FocusedValues {
    struct DocumentFocusedValues: FocusedValueKey {
        typealias Value = Binding<Document?>
    }
    
    var document: Binding<Document?>? {
        get {
            self[DocumentFocusedValues.self]
        }
        set {
            self[DocumentFocusedValues.self] = newValue
        }
    }
}


@main
struct qlviewApp: App {
    @Environment(\.dismiss) private var dismiss
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @FocusedBinding(\.document) var document
    @State private var showAbout = false
        
    var body: some Scene {
        WindowGroup(for: Document.self) { $doc in
            ContentView(doc: doc)
                .navigationTitle(doc?.url.lastPathComponent ?? "")
                .focusedSceneValue(\.document, $doc)
                .onKeyPress(keys: [.escape], action: { _ in
                    NSApplication.shared.keyWindow?.close()
                    return KeyPress.Result.handled
                    })
                .ifLet(doc) {
                    $0.navigationDocument($1.url)
                }
                .sheet(isPresented: $showAbout) {
                    AboutView(showAbout: $showAbout)
                }
        }
        .defaultSize(width: 800, height: 600)
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button("About qlview") { showAbout = true }
            }
            CommandGroup(after: .newItem, addition: {
                
                Divider()
                
                Button("Open in App") {
                    guard let document = document else { return }
                    guard let document = document else { return }
                    
                    document.open()
                    NSApplication.shared.keyWindow?.close()
                }
                .keyboardShortcut("o", modifiers: .command)
                
                Button("Move To ...") {
                    guard let document = document else { return }
                    guard let document = document else { return }
                    
                    if document.move() {
                        NSApplication.shared.keyWindow?.close()
                    }
                    
                }
                .keyboardShortcut("m", modifiers: .command)
                
                Divider()
                
                Button("Print ...") {
                    guard let document = document else { return }
                    guard let document = document else { return }
                    
                    document.print()
                }
                .keyboardShortcut("p", modifiers: .command)
            })
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    @Environment(\.openWindow) private var openWindow
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
        // NSApp.setActivationPolicy(.accessory) // No menu bar, no dock
        
        let documents = CommandLine.arguments.suffix(from: 1).enumerated().map({ (idx, url) in
            return Document(url: URL(fileURLWithPath: url), id: idx)
        })

        if !documents.isEmpty {
            // Close the intial window.
            // TODO: Is there a way to prevent this from opening in the 1st place?
            // UPDATE: Apparently not!
            if let window = NSApplication.shared.windows.first {
                window.close()
            }
        }
            
        for doc in documents {
            openWindow(value: doc)
        }
    }

    private var aboutBoxWindowController: NSWindowController?

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
           return false
       }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
