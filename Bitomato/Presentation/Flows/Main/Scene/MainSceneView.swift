import SwiftUI

struct MainSceneView<ViewModel: MainSceneViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var hasAppeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Spot")
                    .font(.title2)
                    .foregroundColor(.interfaceBlack)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)

            if viewModel.isLoading && viewModel.displayMarkets.isEmpty {
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .interfaceBlack))
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                MarketListView(markets: viewModel.displayMarkets)
                    .refreshable {
                        await Task {
                            await viewModel.fetch()
                        }.value
                    }
            }
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 16)
        .task {
            if !hasAppeared {
                hasAppeared = true
                await viewModel.fetch()
            }
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

