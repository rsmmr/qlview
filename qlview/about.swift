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
    @Binding var showAbout: Bool;
    
    var body: some View {
        VStack(spacing: 10) {
            //Image(nsImage: NSImage(named: "AppIcon")!)
            
            Text(Bundle.main.bundleName)
                .font(.system(size: 20, weight: .bold))
            
            Text("Version \(Bundle.main.bundleVersion)")
                .textSelection(.enabled)
            
            Text("© 2023 Robin Sommer")
                .font(.system(size: 10, weight: .thin))
                .multilineTextAlignment(.center)

            Spacer()
            
            Link("GitHub", destination: URL(string: "https://github.com/rsmmr/qlview")! )
                        
            Spacer()
            Button("Close", action: { showAbout = false })
            Spacer ()
        }
        .padding(50)
    }
}
