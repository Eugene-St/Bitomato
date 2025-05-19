final class MockMarketDataManager: MarketDataManagerProtocol {
    func fetchMarketsInfo() async throws -> MarketDataResponse {
        let currency = Currency(
            tabName: "BTC/USDT",
            pairName: "BTC/USDT",
            favorite: false,
            id: 1,
            isSto: false,
            stockIcon: nil,
            moneyIcon: nil,
            stockLabel: "BTC",
            moneyLabel: "USDT",
            price: "48000.0",
            priceUsd: "48000.0",
            high: "50000",
            change: "0.0",
            low: "47000",
            volume: "10000000",
            deal: "1000000000",
            priority: 1,
            minAmount: "10",
            maxAmount: "100000",
            stepSize: "0.01",
            minPrice: "100",
            maxPrice: "1000000",
            tickSize: "0.1",
            minTotal: "10",
            stockPrecision: 2,
            moneyPrecision: 2,
            enabledInTradingDate: nil,
            isNew: false,
            zeroFee: false,
            preDelisting: false
        )

        let tabs = Tabs(ALTS: nil, BTC: "USDT", DeFi: nil, OTHER: nil, USDs: nil)
        let currencies = ["BTC_USDT": currency]

        return MarketDataResponse(response: MarketDataInnerResponse(
            precisions: [:],
            tabs: tabs,
            currencies: currencies
        ))
    }
}
