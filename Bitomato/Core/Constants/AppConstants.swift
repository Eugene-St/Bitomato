typealias CompletionBlock = (() -> Void)
typealias ItemCompletionBlock<Item> = ((Item) -> Void)

enum AppConstants {
    enum UserDefaultsKey {}
    enum Keys {
        static let baseURL = "https://p2pb2b.com"
    }
    enum Flags {}
    enum SwiftDataConfiguration {}
}
