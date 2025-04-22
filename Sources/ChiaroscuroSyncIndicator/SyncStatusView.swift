import SwiftUI
import Observation

public struct SyncStatusView: View {
    @Environment(\.syncStatusObserver) var observer
    
    public init() {
    }
    
    public var body: some View {
        contentView
            .animation(.easeInOut(duration: 0.3), value: observer.state)
            .padding([.horizontal], 8)
            .padding([.vertical], 4)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch observer.state {
        case .syncing:
            syncingImage
                .transition(.opacity)
        case .error:
            Image(systemName: "exclamationmark.icloud.fill")
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(.red)
                .symbolEffect(.pulse, options: .repeating)
                .transition(.opacity)
        case .success(let date):
            if Date().timeIntervalSince(date) < 60 {
                Image(systemName: "checkmark.icloud.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.green)
                    .transition(.opacity)
            } else {
                EmptyView()
            }
        case .idle:
            EmptyView()
        }
    }
    
    private var syncingImage: some View {
        let view = Image(systemName: "arrow.triangle.2.circlepath.icloud")
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.blue)
        
        if #available(iOS 18.0, *) {
            return view.symbolEffect(.bounce, options: .repeating)
        } else {
            return view
        }
    }
}

public extension View {
    func withSyncStatusObserver(_ observer: SyncStatusObserver) -> some View {
        self.environment(\.syncStatusObserver, observer)
    }
}


private struct SyncStatusObserverKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue = SyncStatusObserver()
}

public extension EnvironmentValues {
    var syncStatusObserver: SyncStatusObserver {
        get { self[SyncStatusObserverKey.self] }
        set { self[SyncStatusObserverKey.self] = newValue }
    }
}
