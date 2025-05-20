import SwiftUI

struct MainSceneView<ViewModel: MainSceneViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if !(viewModel.isLoading && viewModel.displayMarkets.isEmpty) {
                Text("Spot")
                    .font(.title2).bold()
                    .foregroundColor(.interfaceBlack)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TabPickerView(tabs: viewModel.tabsList, selected: viewModel.selectedTab) { tab in
                    withAnimation {
                        viewModel.selectTab(tab)
                    }
                }
                .padding(.top, 14)
                
                TagPickerView(tags: viewModel.currentTags, selected: viewModel.selectedTag) { tag in
                    withAnimation {
                        viewModel.selectTag(tag)
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                MarketListHeaderView(
                    currentSort: viewModel.sortField,
                    direction: viewModel.sortDirection,
                    onSort: { viewModel.toggleSort(by: $0) }
                )
                .padding(.top, 4)
                .padding(.bottom, 12)
                .padding(.horizontal, 6)
            }
            ZStack {
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 0) {
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            MarketListView(markets: viewModel.displayMarkets)
                                .padding(.top, 8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .refreshable {
                    await Task { await viewModel.fetch() }.value
                }
                
                if viewModel.isLoading && viewModel.displayMarkets.isEmpty {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .interfaceBlack))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 10)
        .background(Color.white)
        .task {
            await viewModel.fetch()
        }
    }
}

#Preview {
    MainSceneView(viewModel: MockMainSceneViewModel())
}
