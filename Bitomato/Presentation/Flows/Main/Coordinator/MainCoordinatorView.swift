import SwiftUI

struct MainCoordinatorView: View {
    @StateObject var coordinator: MainCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.mainScene
                .navigationDestination(for: MainRoute.self) { route in }
        }
    }
}
