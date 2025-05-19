import SwiftUI

final class AppCoordinator: BaseCoordinator {
    private let factory: CoordinatorFactory
    private(set) var mainCoordinator: MainCoordinator?
    
    @Published var flow: AppFlow? {
        didSet {
            if oldValue != flow {
                startAppropriateFlow()
            }
        }
    }
    
    init(factory: CoordinatorFactory) {
        self.factory = factory
    }
    
    override func start() {
        flow = .main
    }
    
    private func startAppropriateFlow() {
        removeAllChildren()
        
        switch flow {
        case .main:
            mainCoordinator = nil
            let main = factory.makeMainCoordinator()
            mainCoordinator = main
            addDependency(main)
        case .none:
            break
        }
    }
}
