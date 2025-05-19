struct MarketWebSocketUpdate: Decodable {
    let method: String
    let params: MarketParams?
    let id: Int?
}

struct MarketParams: Decodable {
    let symbol: String
    let payload: MarketUpdatePayload

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        guard !container.isAtEnd else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Empty params array")
        }

        self.symbol = try container.decode(String.self)
        self.payload = try container.decode(MarketUpdatePayload.self)
    }
}

struct MarketUpdatePayload: Decodable {
    let period: Int?
    let last: String?
    let open: String?
    let close: String?
    let high: String?
    let low: String?
    let volume: String?
    let deal: String?
    var change: String?
}
