import SwiftUI
import Combine

protocol MainSceneViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var error: String? { get }
    func loadCurrencies() async
}

final class MainSceneViewModel: MainSceneViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private weak var navigator: MainNavigation?
    private var timer: AnyCancellable?
    
    init(navigator: MainNavigation) {
        self.navigator = navigator
    }
    
    // MARK: - Private Helpers
    @MainActor
    func loadCurrencies() async {
        print(">>>> DEBUG: Fetch")
    }
}

