import SwiftUI
import Combine

protocol MainSceneViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var displayMarkets: [MarketDisplayModel] { get }
    var sortField: MarketSortField { get }
    var sortDirection: SortDirection { get }

    var tabsList: [String] { get }
    var currentTags: [String] { get }
    var selectedTab: String { get }
    var selectedTag: String? { get }

    func fetch() async
    func selectTab(_ tab: String)
    func selectTag(_ tag: String)
    func toggleSort(by field: MarketSortField)
}

final class MainSceneViewModel: MainSceneViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published private(set) var displayMarkets: [MarketDisplayModel] = []

    @Published var selectedTab: String = "BTC"
    @Published var selectedTag: String?
    
    @Published var sortField: MarketSortField = .volume
    @Published var sortDirection: SortDirection = .descending
    
    private var webSocketService: MarketWebSocketServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var pendingUpdates: [String: MarketUpdatePayload] = [:]
    private var allCurrencies: [String: Currency] = [:]
    private var tabs: Tabs?
    private let marketManager: MarketDataManagerProtocol
    private weak var navigator: MainNavigation?
    
    init(navigator: MainNavigation,
         marketManager: MarketDataManagerProtocol,
         webSocketService: MarketWebSocketServiceProtocol) {
        self.navigator = navigator
        self.marketManager = marketManager
        self.webSocketService = webSocketService
        setupWebSocketUpdates()
    }

    @MainActor
    func fetch() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await marketManager.fetchMarketsInfo()
            let marketIds = Array(result.response.currencies.keys)
            webSocketService.connect(to: marketIds)
            allCurrencies = result.response.currencies
            tabs = result.response.tabs
            selectedTag = currentTags.first
            applyFilter()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func applyFilter() {
        guard let selectedTag = selectedTag else {
            displayMarkets = []
            return
        }

        let filtered = allCurrencies
            .filter { currencyEntry in
                        let components = currencyEntry.value.tabName.split(separator: "/").map { String($0).uppercased() }
                        return components.contains(selectedTab.uppercased()) &&
                               components.contains(selectedTag.uppercased())
                    }
            .map { key, currency in
                MarketDisplayModel(
                    id: key,
                    pair: currency.pairName,
                    price: MarketMapper.formatLargeNumber(currency.price),
                    priceUsd: "$\(MarketMapper.formatUsd(currency.priceUsd))",
                    change: currency.change,
                    volume: "Vol \(MarketMapper.formatVolume(currency.volume))",
                    iconURL: currency.stockIcon
                )
            }

        displayMarkets = sort(markets: filtered)
    }

    // MARK: - Private Helpers
    private func sort(markets: [MarketDisplayModel]) -> [MarketDisplayModel] {
        guard sortDirection != .none else {
            return markets.sorted(by: { MarketMapper.parseVolume($0.volume) > MarketMapper.parseVolume($1.volume) })
        }

        let ascending = sortDirection == .ascending

        switch sortField {
        case .name:
            return markets.sorted { ascending ? $0.pair < $1.pair : $0.pair > $1.pair }
        case .volume:
            return markets.sorted { ascending
                ? MarketMapper.parseVolume($0.volume) < MarketMapper.parseVolume($1.volume)
                : MarketMapper.parseVolume($0.volume) > MarketMapper.parseVolume($1.volume)
            }
        case .last:
            return markets.sorted { ascending
                ? Double($0.price) ?? 0 < Double($1.price) ?? 0
                : Double($0.price) ?? 0 > Double($1.price) ?? 0
            }
        case .change:
            return markets.sorted { ascending
                ? Double($0.change) ?? 0 < Double($1.change) ?? 0
                : Double($0.change) ?? 0 > Double($1.change) ?? 0
            }
        }
    }
    
    private func setupWebSocketUpdates() {        
        webSocketService.onMessage
            .sink { [weak self] update in
                guard let self = self else { return }
                guard update.method == "state.update" else { return }
                guard let params = update.params else {
                    self.errorMessage = "Invalid params in WebSocket update: \(update)"
                    return
                }

                self.pendingUpdates[params.symbol] = params.payload
            }
            .store(in: &cancellables)

        webSocketService.onError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.errorMessage = errorMessage
            }
            .store(in: &cancellables)

        Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.applyWebSocketUpdates() }
            .store(in: &cancellables)
    }
    
    func applyWebSocketUpdates() {
        for (key, update) in pendingUpdates {
            guard var currency = allCurrencies[key] else { continue }

            if let last = update.last {
                currency.price = last
            }

            if let volume = update.volume {
                currency.volume = volume
            }

            if let change = update.change {
                currency.change = change
            } else if let openStr = update.open,
                      let lastStr = update.last,
                      let open = Double(openStr),
                      let last = Double(lastStr),
                      open != 0 {
                let calculated = ((last - open) / open) * 100
                let change = String(format: "%.2f", calculated)
                currency.change = change
            }
            allCurrencies[key] = currency
        }
        pendingUpdates.removeAll()
        applyFilter()
    }

    func toggleSort(by field: MarketSortField) {
        if sortField == field {
            sortDirection.toggle()
        } else {
            sortField = field
            sortDirection = .descending
        }
        applyFilter()
    }

    var tabsList: [String] {
        guard let tabs = tabs else { return [] }

        return Mirror(reflecting: tabs)
            .children
            .compactMap { label, value in
                if let array = value as? [String], !array.isEmpty { return label?.uppercased() }
                if let string = value as? String, !string.isEmpty { return label?.uppercased() }
                return nil
            }
    }

    var currentTags: [String] {
        guard let tabs = tabs else { return [] }
        switch selectedTab {
        case "USDS": return tabs.USDs ?? []
        case "BTC": return tabs.BTC.map { [$0] } ?? []
        case "DEFI": return tabs.DeFi ?? []
        case "OTHER": return tabs.OTHER ?? []
        case "ALTS": return tabs.ALTS ?? []
        default: return []
        }
    }

    func selectTab(_ tab: String) {
        selectedTab = tab
        selectedTag = currentTags.first
        applyFilter()
    }

    func selectTag(_ tag: String) {
        selectedTag = tag
        applyFilter()
    }
}
