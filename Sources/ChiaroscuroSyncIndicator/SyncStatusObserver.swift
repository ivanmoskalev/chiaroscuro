import CloudKit
import Combine
import CoreData
import Observation
import SwiftData
import SwiftUI

public enum SyncState: Equatable {
    case idle
    case syncing
    case success(date: Date)
    case error(Error)

    public static func == (lhs: SyncState, rhs: SyncState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            true
        case (.syncing, .syncing):
            true
        case let (.success(lDate), .success(rDate)):
            lDate == rDate
        case (.error, .error):
            true
        default:
            false
        }
    }
}

@Observable
public final class SyncStatusObserver {
    public var state: SyncState = .idle
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

    public init() {
        NotificationCenter.default.publisher(for: ModelContext.didSave)
            .sink { [weak self] _ in
                self?.state = .syncing
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] notification in
                guard let event = notification.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else {
                    return
                }

                switch event.type {
                case .setup, .import, .export:
                    switch event.endDate {
                    case .none:
                        self?.state = .syncing
                    case .some:
                        if event.succeeded {
                            self?.state = .success(date: Date())
                        } else if let error = event.error {
                            self?.state = .error(error)
                        }
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
