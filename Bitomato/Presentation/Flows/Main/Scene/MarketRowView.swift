import SwiftUI

import SwiftUI

struct MarketRowView: View {
    let model: MarketDisplayModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text(model.baseAsset)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.interfaceBlack)

                    Text("/\(model.quoteAsset)")
                        .font(.subheadline)
                        .foregroundColor(.interfaceGrey)
                }

                Text(model.volume)
                    .font(.caption)
                    .foregroundColor(.interfaceGrey)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(model.price.formatPriceWithSpaces())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.interfaceBlack)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(model.priceUsd)
                    .font(.caption2)
                    .foregroundColor(.interfaceGrey)
            }

            MarketChangeView(change: model.change)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MarketRowView(model: MarketDisplayModel(
        id: "BTC_USDT",
        pair: "BTC/USDT",
        price: "0.000 000 000 189",
        priceUsd: "$43024.23",
        change: "+2.89",
        volume: "Vol 288.35M",
        iconURL: nil
    )).padding(20)
}
