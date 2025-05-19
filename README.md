A lightweight, modular SwiftUI application for real-time cryptocurrency market tracking, built using Swift 6.0, MVVM+C, and Clean Architecture.

🔧 Tech Stack
Language: Swift 6.0
UI: SwiftUI + Observation Framework
Architecture: MVVM + Coordinator + Clean Architecture
Async Networking: async/await, URLSession
WebSocket Streaming: Native URLSessionWebSocketTask
Dependency Injection: Factory
Testing: XCTest + Combine
Preview Support: Fully functional SwiftUI previews using mocked data

📡 Live Data Integration
The app fetches market data from:
GET https://p2pb2b.com/v2/market-list/new
Once loaded, it subscribes to market updates using a WebSocket connection to:
wss://ws.p2pb2b.com/ws
🔁 Subscription Message Example
{
  "method": "state.subscribe",
  "params": ["BTC_USDT", "ETH_USDT"],
  "id": 1
}
Market updates are received individually per market. These are batched and pushed to the view every 3 seconds using a timer to avoid UI overload and ensure smooth rendering.

🔁 Pull to Refresh
Swipe down on the market list to manually trigger a data refresh via async call to the API endpoint.

↕️ Sorting Logic
Markets can be sorted by:
Name
Last Price
24H Change
Volume (default)
Sorting Behavior:
Tapping once sorts the field descending (e.g. Z → A)
Tapping again switches to ascending (A → Z)
Tapping a third time resets to the default sort (by Volume descending)

✅ Unit Tests
Unit tests are written using XCTest and cover:
fetch() logic: verifies API data loads and state updates
WebSocket updates: verifies currency prices and change values update properly
Sorting: toggles field/direction logic
Tab/tag filtering: ensures market list reflects selected filters
All ViewModel behavior is tested in isolation using mock data providers and services.

🧪 Preview Support
SwiftUI previews are enabled for all views:
MainSceneView
Reusable components (e.g. MarketListView, HeaderView, etc.)
Mock ViewModels ensure realistic preview behavior without live data.

📌 Requirements
iOS 17+
Swift 6.0
Xcode 15+

🧼 No 3rd-party networking
This project intentionally avoids any third-party networking libraries like Alamofire. All data is fetched and streamed using native URLSession.
