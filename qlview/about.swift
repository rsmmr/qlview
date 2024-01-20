// Copyright (c) 2024 by Robin Sommer. See LICENSE for details.

import SwiftUI

extension Bundle {
    var bundleName: String {
        return (object(forInfoDictionaryKey: "CFBundleName") as? String) ?? "<unknown>"
    }

    var bundleVersion: String {
        return (object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "<unknown>"
    }
}

struct AboutView: View {
    @Binding var showAbout: Bool

    var body: some View {
        VStack(spacing: 10) {
            //Image(nsImage: NSImage(named: "AppIcon")!)

            Text(Bundle.main.bundleName)
                .font(.headline)

            Text("Version \(Bundle.main.bundleVersion)")
                .font(.subheadline)

            Text("© 2024 Robin Sommer")
                .font(.system(.footnote, weight: .thin))

            Spacer()

            HStack {
                Link("GitHub", destination: URL(string: "https://github.com/rsmmr/qlview")!)
                Link(
                    "License",
                    destination: URL(
                        string:
                            "https://raw.githubusercontent.com/rsmmr/qlview/main/LICENSE?token=GHSAT0AAAAAACLOI6MX53ZVUFTKWHB4O5CCZNMF5WA"
                    )!)
            }
            .font(.system(.body, design: .monospaced))

            Spacer()

            Button("Close", action: { showAbout = false })
        }
        .frame(minWidth: 200)
        .padding(25)
    }
}
