protocol MarketDataManagerProtocol {
    func fetchMarketsInfo() async throws -> MarketDataResponse
}

final class MarketDataManagerImpl: MarketDataManagerProtocol {
    private let service: NetworkServiceProtocol

    init(service: NetworkServiceProtocol) {
        self.service = service
    }

    func fetchMarketsInfo() async throws -> MarketDataResponse {
        let response: MarketDataResponse = try await service.request(.markets)
        return response
    }
}
