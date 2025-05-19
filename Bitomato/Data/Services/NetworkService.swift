import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    case unknown(Error)
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ route: APIRoute) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL: String

    init(baseURL: String = AppConstants.Keys.baseURL) {
        self.baseURL = baseURL
    }

    func request<T: Decodable>(_ route: APIRoute) async throws -> T {
        guard var components = URLComponents(string: baseURL + route.path) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = route.queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = route.method.rawValue
        request.httpBody = route.body

        route.headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
