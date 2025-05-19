import Foundation
import Network

protocol NetworkMonitor {
    var isConnected: Bool { get }
}

final class NetworkMonitorImpl: NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private var currentStatus: NWPath.Status = .requiresConnection

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.currentStatus = path.status
        }
        monitor.start(queue: queue)
    }

    var isConnected: Bool {
        currentStatus == .satisfied
    }
}
