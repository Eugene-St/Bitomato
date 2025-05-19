import SwiftUI

protocol Coordinatable: AnyObject {
    var childCoordinators: [Coordinatable] { get set }
    func start()
    func addDependency(_ coordinator: Coordinatable)
    func removeDependency(_ coordinator: Coordinatable)
    func removeAllChildren()
}

class BaseCoordinator: Coordinatable, ObservableObject {
    var childCoordinators: [Coordinatable] = []
    
    func start() {}
    
    func addDependency(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinatable) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    func removeAllChildren() {
        childCoordinators.removeAll()
    }
}
