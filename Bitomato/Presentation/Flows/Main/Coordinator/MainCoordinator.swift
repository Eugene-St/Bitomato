import SwiftUI

final class MainCoordinator: BaseCoordinator, MainNavigation {    
    @Published var path = NavigationPath()
    private var container: MainDIContainer?
    private(set) lazy var mainScene: some View = {
        setMainSceneView()
    }()
    
    func setContainer(_ container: MainDIContainer) {
        self.container = container
    }
    
    func setMainSceneView() -> some View {
        container?.makeMainScene(navigator: self)
    }
}
