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
