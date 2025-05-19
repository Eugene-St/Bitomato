import SwiftUI
import SwiftData

final class MainDIContainer {
    private let navigator: MainNavigation
    private let networkService: NetworkServiceProtocol
    private let networkMonitor: NetworkMonitor
    
    init(navigator: MainNavigation,
         networkMonitor: NetworkMonitor) {
        self.navigator = navigator
        self.networkService = NetworkService()
        self.networkMonitor = networkMonitor
    }
    
    func makeMainScene(navigator: MainNavigation) -> some View {
        MainSceneView(viewModel: makeMainViewModel(navigator: navigator))
    }
    
    // MARK: - Private
    private func makeMainViewModel(navigator: MainNavigation) -> MainSceneViewModel {
        .init(navigator: navigator, marketManager: MarketDataManagerImpl(service: networkService))
    }
}
