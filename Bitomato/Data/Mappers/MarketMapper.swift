struct MarketMapper {
    static func map(from response: MarketDataInnerResponse) -> [MarketDisplayModel] {
        return response.currencies.map { key, currency in
            MarketDisplayModel(
                id: key,
                pair: currency.pairName,
                price: currency.price,
                priceUsd: "$\(formatUsd(currency.priceUsd))",
                change: currency.change,
                volume: "Vol \(formatVolume(currency.volume))",
                iconURL: currency.stockIcon
            )
        }.sorted(by: { $0.pair < $1.pair })
    }
    
    static func formatLargeNumber(_ value: String) -> String {
        guard let double = Double(value) else { return value }
        return String(format: "%.12f", double)
    }
    
    static func formatUsd(_ value: String) -> String {
        guard let double = Double(value) else { return value }
        return String(format: "%.2f", double)
    }
    
    static func formatVolume(_ value: String) -> String {
        guard let double = Double(value) else { return value }
        if double > 1_000_000 {
            return "\(String(format: "%.2f", double / 1_000_000))M"
        }
        return String(format: "%.2f", double)
    }
    
    static func parseVolume(_ volume: String) -> Double {
        let cleaned = volume.replacingOccurrences(of: "Vol ", with: "").replacingOccurrences(of: "M", with: "")
        return Double(cleaned) ?? 0
    }
}

struct MarketDisplayModel: Identifiable {
    let id: String
    let pair: String
    let price: String
    let priceUsd: String
    let change: String
    let volume: String
    let iconURL: String?
}

extension MarketDisplayModel {
    var baseAsset: String {
        pair.components(separatedBy: "/").first ?? pair
    }
    
    var quoteAsset: String {
        pair.components(separatedBy: "/").last ?? ""
    }
}
