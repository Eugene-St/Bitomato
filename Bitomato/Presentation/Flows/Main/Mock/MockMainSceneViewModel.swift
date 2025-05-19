final class MockMainSceneViewModel: MainSceneViewModelProtocol {
    var sortField: MarketSortField = .change
    var sortDirection: SortDirection = .ascending
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var displayMarkets: [MarketDisplayModel] = [
        .init(id: "BTC_USDT", pair: "BTC/USDT", price: "43000.00", priceUsd: "$43000", change: "+2.5", volume: "Vol 32M", iconURL: nil),
        .init(id: "ETH_USDT", pair: "ETH/USDT", price: "3000.00", priceUsd: "$3000", change: "-1.2", volume: "Vol 15M", iconURL: nil)
    ]

    var tabsList: [String] = ["USD", "BTC", "DEFI"]
    var currentTags: [String] = ["USDT", "USDC"]
    var selectedTab: String = "USD"
    var selectedTag: String? = "USDT"

    func fetch() async {}
    func selectTab(_ tab: String) {}
    func selectTag(_ tag: String) {}
    func toggleSort(by field: MarketSortField) {}
}
