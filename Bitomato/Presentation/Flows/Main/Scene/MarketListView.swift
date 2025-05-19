import SwiftUI

struct MarketListView: View {
    let markets: [MarketDisplayModel]

    var body: some View {
        ScrollView(showsIndicators: true) {
            LazyVStack(spacing: 12) {
                ForEach(markets) { market in
                    MarketRowView(model: market)
                        .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    MarketListView(markets: [
        MarketDisplayModel(id: "BTC_USDT", pair: "BTC/USDT", price: "0.000 000 000 189", priceUsd: "$43024.23", change: "+2.89", volume: "Vol 288.35M", iconURL: nil),
        MarketDisplayModel(id: "ETH_USDT", pair: "ETH/USDT", price: "0.000 000 000 189", priceUsd: "$2299.73", change: "+1.52", volume: "Vol 115.92M", iconURL: nil)
    ])
}
