import Foundation

enum APIRoute {
    case markets

    var method: HTTPMethod {
        switch self {
        case .markets:
            return .get
        }
    }

    var path: String {
        switch self {
        case .markets:
            return "/v2/market-list/new"
        }
    }

    var headers: [String: String]? {
        switch self {
        case .markets:
            return ["Accept": "application/json"]
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .markets:
            return nil
        }
    }

    var body: Data? {
        switch self {
        case .markets:
            return nil
        }
    }
}
