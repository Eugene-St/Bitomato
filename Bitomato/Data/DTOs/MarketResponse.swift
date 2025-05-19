struct MarketDataResponse: Decodable {
    let response: MarketDataInnerResponse
}

struct MarketDataInnerResponse: Decodable {
    let precisions: [String: Precision]
    let tabs: Tabs
    let currencies: [String: Currency]
}

struct Precision: Decodable {
    let money: Int
    let stock: Int
}

struct Tabs: Decodable {
    let ALTS: [String]?
    let BTC: String?
    let DeFi: [String]?
    let OTHER: [String]?
    let USDs: [String]?
}

struct Currency: Decodable {
    let tabName: String
    let pairName: String
    let favorite: Bool
    let id: Int
    let isSto: Bool
    let stockIcon: String?
    let moneyIcon: String?
    let stockLabel: String
    let moneyLabel: String
    var price: String
    let priceUsd: String
    let high: String
    var change: String
    let low: String
    var volume: String
    let deal: String
    let priority: Int
    let minAmount: String
    let maxAmount: String
    let stepSize: String
    let minPrice: String
    let maxPrice: String
    let tickSize: String
    let minTotal: String
    let stockPrecision: Int
    let moneyPrecision: Int
    let enabledInTradingDate: String?
    let isNew: Bool
    let zeroFee: Bool
    let preDelisting: Bool

    enum CodingKeys: String, CodingKey {
        case tabName
        case pairName
        case favorite
        case id
        case isSto
        case stockIcon = "stock_icon"
        case moneyIcon = "money_icon"
        case stockLabel = "stock_label"
        case moneyLabel = "money_label"
        case price
        case priceUsd
        case high
        case change
        case low
        case volume
        case deal
        case priority
        case minAmount = "min_amount"
        case maxAmount = "max_amount"
        case stepSize = "step_size"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case tickSize = "tick_size"
        case minTotal = "min_total"
        case stockPrecision = "stock_precision"
        case moneyPrecision = "money_precision"
        case enabledInTradingDate = "enabled_in_trading_date"
        case isNew = "new"
        case zeroFee
        case preDelisting
    }
}

