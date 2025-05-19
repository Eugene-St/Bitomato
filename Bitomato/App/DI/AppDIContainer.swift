import SwiftData

protocol AppDIContainer {
    func makeMainDIContainer(navigator: MainNavigation) -> MainDIContainer
}

final class AppDIContainerImpl: AppDIContainer {
    
    // MARK: - Shared services
    private let networkMonitor: NetworkMonitor = NetworkMonitorImpl()
    
    init() {}
    
    // MARK: - Flow containers
    func makeMainDIContainer(navigator: MainNavigation) -> MainDIContainer {
        MainDIContainer(navigator: navigator,
                        networkMonitor: networkMonitor)
    }
}

