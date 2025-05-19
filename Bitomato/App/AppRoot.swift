import SwiftUI
import SwiftData

struct AppRoot: View {

    var body: some View {
        let appDI = AppDIContainerImpl()
        let coordinator = AppCoordinator(
            factory: CoordinatorFactoryImpl(appDIContainer: appDI)
        )

        AppCoordinatorView(coordinator: coordinator)
            .onAppear {
                coordinator.start()
            }
    }
}
