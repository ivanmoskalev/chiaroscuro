import SwiftUI

public extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

public extension Color {
    static let orangeBlaze = Color(hex: 0xF3671A)
    static let honeyYellow = Color(hex: 0xF6AE2D)
    static let jet = Color(hex: 0x313038)
    static let isabelline = Color(hex: 0xF5F3F0)
    static let persianOrange = Color(hex: 0xCB904D)
    static let softIsabelline = Color.isabelline.opacity(0.85)
}

public extension LinearGradient {
    static let honeyBlaze = LinearGradient(
        gradient: Gradient(colors: [.honeyYellow, .orangeBlaze]),
        startPoint: .bottomLeading, endPoint: .topTrailing
    )
}
