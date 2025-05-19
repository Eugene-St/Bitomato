import SwiftUI

struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        Group {
            switch coordinator.flow {
            case .main:
                if let main = coordinator.mainCoordinator {
                    MainCoordinatorView(coordinator: main)
                }
            case .none:
                EmptyView()
            }
        }
    }
}


