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
    private var subscribedMarkets: [String] = []
    private let url = URL(string: "wss://ws.p2pb2b.com/ws")
    private(set) var isConnected = false
    private var isReceiving = false

    let onMessage = PassthroughSubject<MarketWebSocketUpdate, Never>()
    let onError = PassthroughSubject<String, Never>()

    func connect(to markets: [String]) {
        disconnect()

        subscribedMarkets = markets
        guard let url else {
            self.onError.send("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.sendSubscribe()
            self.startReceiving()
            self.isConnected = true
        }
    }

    func disconnect() {
        isConnected = false
        isReceiving = false
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }

    private func sendSubscribe() {
        guard !subscribedMarkets.isEmpty else { return }

        let subscribeMessage: [String: Any] = [
            "method": "state.subscribe",
            "params": subscribedMarkets,
            "id": 1
        ]

        if let data = try? JSONSerialization.data(withJSONObject: subscribeMessage),
           let json = String(data: data, encoding: .utf8) {
            webSocketTask?.send(.string(json)) { error in
                if let error = error {
                    self.onError.send("WS Send Error: \(error.localizedDescription)")
                }
            }
        }
    }

    private func startReceiving() {
        guard !isReceiving else { return }
        isReceiving = true
        receive()
    }

    private func receive() {
        guard let task = webSocketTask else {
            return
        }

        task.receive { [weak self] result in
            guard let self = self else { return }

            if !self.isConnected {
                return
            }

            switch result {
            case .failure(let error):
                self.onError.send("WS Receive Error: \(error.localizedDescription)")
                self.isConnected = false
                self.isReceiving = false
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8),
                       let decoded = try? JSONDecoder().decode(MarketWebSocketUpdate.self, from: data) {
                        self.onMessage.send(decoded)
                    }
                default:
                    break
                }
                self.receive()
            }
        }
    }
}

