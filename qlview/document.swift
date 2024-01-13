import SwiftUI

struct Document: Identifiable, Codable, Hashable {
    var url: URL
    let id: Int
    
    var prettyURL: String {
        if url.isFileURL {
            return url.standardizedFileURL.path
        }
        else {
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
        panel.message = "Select folder to move document to"
        panel.canCreateDirectories = true
        panel.showsTagField = false
        panel.nameFieldStringValue = url.lastPathComponent
        
        if panel.runModal() == .OK {
            if let dst = panel.url {
                do {
                    try FileManager.default.moveItem(at: url, to: dst)
                    return true
                }
                catch {
                    showAlert(msg: "Error", sub: "Moving failed.", style: .critical)
                }
            }
        }
            return false
    }
   
    
    func print() {
        showAlert(msg: "Error", sub: "Printing not yet implemented.", style: .critical)
//        let nsview = view.makeNSView(context: nil)
//
//        let view = QLView(url: url, qlview: nsview)
//        let renderer = ImageRenderer(content: AnyView(view) )
//        let nsview = view.makeNSView(context: nil)
//        let printInfo = NSPrintInfo()
//        let printOperation = NSPrintOperation(view: view)
//        printOperation.showsPrintPanel = true
//        printOperation.showsProgressPanel = true
//        printOperation.run()
    }

}
