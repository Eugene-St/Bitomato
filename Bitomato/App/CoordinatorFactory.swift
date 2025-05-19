protocol CoordinatorFactory {
    func makeMainCoordinator() -> MainCoordinator
}

final class CoordinatorFactoryImpl: CoordinatorFactory {
    let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    func makeMainCoordinator() -> MainCoordinator {
        let coordinator = MainCoordinator()
        let container = appDIContainer.makeMainDIContainer(navigator: coordinator)
        coordinator.setContainer(container)
        return coordinator
    }
}
