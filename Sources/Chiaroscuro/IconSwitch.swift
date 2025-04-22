import SwiftUI

public struct IconSwitch: View {
    private let isEnabled: Bool
    private let offIcon: String
    private let onIcon: String

    private let animation: Animation = .interpolatingSpring(stiffness: 170, damping: 15)

    public init(isEnabled: Bool, offIcon: String, onIcon: String) {
        self.isEnabled = isEnabled
        self.offIcon = offIcon
        self.onIcon = onIcon
    }

    public var body: some View {
        ZStack {
            Image(systemName: offIcon)
                .opacity(isEnabled ? 0.0 : 1.0)
                .animation(animation, value: isEnabled)

            Image(systemName: onIcon)
                .opacity(isEnabled ? 1.0 : 0.0)
                .animation(animation, value: isEnabled)
        }
        .foregroundColor(.accentColor)
    }
}
