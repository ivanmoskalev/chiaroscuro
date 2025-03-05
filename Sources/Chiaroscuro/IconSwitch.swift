import SwiftUI

/// An animated toggle component that transitions between two SF Symbols.
public struct IconSwitch: View {
    /// Whether the switch is in the enabled state
    private let isEnabled: Bool
    /// The SF Symbol name for the disabled state
    private let offIcon: String
    /// The SF Symbol name for the enabled state
    private let onIcon: String

    private let animation: Animation = .interpolatingSpring(stiffness: 170, damping: 15)

    /// Creates a new IconSwitch
    /// - Parameters:
    ///   - isEnabled: Whether the switch is in the enabled state
    ///   - offIcon: The SF Symbol name for the disabled state
    ///   - onIcon: The SF Symbol name for the enabled state
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
