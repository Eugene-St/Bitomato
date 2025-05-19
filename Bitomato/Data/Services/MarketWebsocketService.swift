import Foundation
import Combine

protocol MarketWebSocketServiceProtocol {
    func connect(to markets: [String])
    func disconnect()
    var onMessage: PassthroughSubject<MarketWebSocketUpdate, Never> { get }
    var onError: PassthroughSubject<String, Never> { get }
}

final class MarketWebSocketService: MarketWebSocketServiceProtocol {
    private var webSocketTask: URLSessionWebSocketTask?
    private let url = URL(string: "wss://ws.p2pb2b.com/ws")
    private var isConnected = false
    
    let onMessage = PassthroughSubject<MarketWebSocketUpdate, Never>()
    let onError = PassthroughSubject<String, Never>()
    
    func connect(to markets: [String]) {
        guard !isConnected else { return }
        
        guard let url = url else {
            onError.send("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        isConnected = true
        
        let subscribeMessage = [
            "method": "state.subscribe",
            "params": markets,
            "id": 1
        ] as [String : Any]
        
        if let data = try? JSONSerialization.data(withJSONObject: subscribeMessage),
           let json = String(data: data, encoding: .utf8) {
            webSocketTask?.send(.string(json)) { _ in }
        }
        
        receive()
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            defer { self.receive() }
            
            switch result {
            case .failure(let error):
                self.onError.send("WebSocket receive error: \(error.localizedDescription)")
            case .success(let message):
                switch message {
                case .string(let json):
                    if let data = json.data(using: .utf8),
                       let decoded = try? JSONDecoder().decode(MarketWebSocketUpdate.self, from: data) {
                        self.onMessage.send(decoded)
                    }
                default: break
                }
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }
}
