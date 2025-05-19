import SwiftUI

struct MainSceneView<ViewModel: MainSceneViewModelProtocol>: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Bitomato!")
        }
        .padding()
    }
}
