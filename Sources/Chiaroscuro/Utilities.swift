import SwiftUI

public extension View {
    func navigationBar(translucent: Bool) -> some View {
        modifier(NavigationBarStyle(translucent: translucent))
    }
}

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
