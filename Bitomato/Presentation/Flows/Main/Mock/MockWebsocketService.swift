import Combine

final class MockWebSocketService: MarketWebSocketServiceProtocol {
    let onMessage = PassthroughSubject<MarketWebSocketUpdate, Never>()
    let onError = PassthroughSubject<String, Never>()
    
    func connect(to markets: [String]) {}
    func disconnect() {}
}
