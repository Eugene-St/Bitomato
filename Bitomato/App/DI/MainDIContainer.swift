import SwiftUI
import SwiftData

final class MainDIContainer {
    private let navigator: MainNavigation
//    private let localDataSource: ExchangeRateLocalDataSource
//    private let remoteDataSource: ExchangeRateRemoteDataSource
    private let networkMonitor: NetworkMonitor
    
    init(navigator: MainNavigation,
         networkMonitor: NetworkMonitor) {
        self.navigator = navigator
//        self.localDataSource = ExchangeRateLocalDataSourceImpl(context: modelContext)
//        self.remoteDataSource = ExchangeRateRemoteDataSourceImpl()
        self.networkMonitor = networkMonitor
    }
    
    func makeMainScene(navigator: MainNavigation) -> some View {
        MainSceneView(viewModel: makeMainViewModel(navigator: navigator))
    }
    
    // MARK: - Private
    private func makeMainViewModel(navigator: MainNavigation) -> MainSceneViewModel {
        .init(navigator: navigator)
    }
}
