import SwiftUI
import Combine

protocol MainSceneViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    func fetch() async
    var displayMarkets: [MarketDisplayModel] { get }
}

final class MainSceneViewModel: MainSceneViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published private(set) var displayMarkets: [MarketDisplayModel] = []
    private weak var navigator: MainNavigation?
    private let marketManager: MarketDataManagerProtocol
    
    init(navigator: MainNavigation, marketManager: MarketDataManagerProtocol) {
        self.navigator = navigator
        self.marketManager = marketManager
    }
    
    // MARK: - Private Helpers
    
    @MainActor
    func fetch() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await marketManager.fetchMarketsInfo()
            self.displayMarkets = MarketMapper.map(from: result.response)
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
