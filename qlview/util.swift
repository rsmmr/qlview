// Copyright (c) 2024 by Robin Sommer. See LICENSE for details.

import SwiftUI

public func showAlert(msg: String, sub: String, style: NSAlert.Style = .informational) {
    let alert = NSAlert()
    alert.messageText = msg
    alert.informativeText = sub
    alert.addButton(withTitle: "OK")
    alert.icon = nil
    alert.alertStyle = style
    alert.runModal()
}

func savedWindowSize(defaultWidth: Double = 800, defaultHeight: Double = 600) -> CGSize {
    let fd = UserDefaults.standard.string(forKey: "MyWindowSize") ?? ""
    let parts = fd.split(separator: " ")
    if parts.count >= 4, let w = Double(parts[2]), let h = Double(parts[3]) {
        return CGSize(width: w, height: h)
    }
    return CGSize(width: defaultWidth, height: defaultHeight)
}

// From https://www.fivestars.blog/articles/conditional-modifiers.
extension View {
    @ViewBuilder
    func ifLet<V, Transform: View>(
        _ value: V?,
        transform: (Self, V) -> Transform
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}
