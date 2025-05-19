import XCTest
import Combine
@testable import Bitomato

final class MainSceneViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    func testFetchSetsInitialState() async {
        let mockManager = MockMarketDataManager()
        let mockSocket = MockWebSocketService()
        let viewModel = MainSceneViewModel(
            navigator: MainCoordinator(),
            marketManager: mockManager,
            webSocketService: mockSocket
        )

        await viewModel.fetch()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.displayMarkets.count, 1)
        XCTAssertEqual(viewModel.tabsList, ["BTC"])
        XCTAssertEqual(viewModel.currentTags, ["USDT"])
    }

    func testApplyWebSocketUpdatesUpdatesCurrency() {
        let mockManager = MockMarketDataManager()
        let mockSocket = MockWebSocketService()
        let viewModel = MainSceneViewModel(navigator: MainCoordinator(), marketManager: mockManager, webSocketService: mockSocket)

        Task {
            await viewModel.fetch()
            viewModel.pendingUpdates = [
                "BTC_USDT": MarketUpdatePayload(
                    period: 86400,
                    last: "50000.0",
                    open: "48000.0",
                    close: nil,
                    high: nil,
                    low: nil,
                    volume: "100000000",
                    deal: nil,
                    change: nil
                )
            ]

            viewModel.applyWebSocketUpdates()

            let updated = viewModel.displayMarkets.first(where: { $0.id == "BTC_USDT" })
            if let price = Double(updated?.price ?? "") {
                XCTAssertEqual(price, 50000.0, accuracy: 0.01)
            } else {
                XCTFail("Failed to convert price to Double")
            }
            if let change = Double(updated?.change ?? "") {
                XCTAssertEqual(change, 4.17, accuracy: 0.01)
            } else {
                XCTFail("Failed to convert change to Double")
            }
        }
    }

    func testToggleSortChangesSortDirection() async {
        let mockManager = MockMarketDataManager()
        let mockSocket = MockWebSocketService()
        let viewModel = MainSceneViewModel(
            navigator: MainCoordinator(),
            marketManager: mockManager,
            webSocketService: mockSocket
        )

        await viewModel.fetch()
        
        viewModel.sortField = .volume
        viewModel.sortDirection = .ascending
        let initial = viewModel.sortDirection

        viewModel.toggleSort(by: .volume)

        XCTAssertNotEqual(viewModel.sortDirection, initial)
    }

    func testSelectTabAndTagUpdatesMarkets() async {
        let mockManager = MockMarketDataManager()
        let mockSocket = MockWebSocketService()
        let viewModel = MainSceneViewModel(
            navigator: MainCoordinator(),
            marketManager: mockManager,
            webSocketService: mockSocket
        )

        await viewModel.fetch()
        viewModel.selectTab("BTC")
        viewModel.selectTag("USDT")

        XCTAssertEqual(viewModel.selectedTab, "BTC")
        XCTAssertEqual(viewModel.selectedTag, "USDT")
        XCTAssertGreaterThan(viewModel.displayMarkets.count, 0)
    }
}
