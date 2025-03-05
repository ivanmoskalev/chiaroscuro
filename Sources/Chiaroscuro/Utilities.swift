import SwiftUI

public extension View {
    /// Sets the navigation bar to translucent or opaque.
    /// - Parameter translucent: Whether the navigation bar should be translucent
    func navigationBar(translucent: Bool) -> some View {
        modifier(NavigationBarStyle(translucent: translucent))
    }
}

/// View modifier for navigation bar appearance.
private struct NavigationBarStyle: ViewModifier {
    let translucent: Bool

    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                if translucent {
                    appearance.configureWithTransparentBackground()
                } else {
                    appearance.configureWithDefaultBackground()
                }

                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}
