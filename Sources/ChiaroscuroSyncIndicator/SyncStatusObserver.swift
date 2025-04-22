import SwiftUI
import SwiftData
import Combine
import CloudKit
import CoreData

public enum SyncState: Equatable {
    case idle
    case syncing
    case success(date: Date)
    case error(Error)
    
    public static func == (lhs: SyncState, rhs: SyncState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.syncing, .syncing):
            return true
        case let (.success(lDate), .success(rDate)):
            return lDate == rDate
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

public final class SyncStatusObserver: ObservableObject {
    @Published public private(set) var state: SyncState = .idle
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] notification in
                guard
                    let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                        as? NSPersistentCloudKitContainer.Event
                else {
                    return
                }
                
                switch event.type {
                case .setup, .import, .export:
                    if event.endDate == nil {
                        self?.state = .syncing
                    } else if event.succeeded {
                        self?.state = .success(date: Date())
                    } else if let error = event.error {
                        self?.state = .error(error)
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
