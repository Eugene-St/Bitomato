import SwiftUI

struct MarketChangeView: View {
    let change: String

    var body: some View {
        Text("\(formattedChange)%")
            .font(.caption)
            .foregroundColor(.white)
            .frame(width: 70, height: 37)
            .background(changeColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var formattedChange: String {
        guard let value = Double(change) else { return change }
        if value > 0 {
            return "+\(String(format: "%.2f", value))"
        } else {
            return String(format: "%.2f", value)
        }
    }

    private var changeColor: Color {
        guard let value = Double(change) else { return .accentGrey }
        if value > 0 {
            return .accentGreen
        } else if value < 0 {
            return .accentRed
        } else {
            return .accentGrey
        }
    }
}

#Preview {
    VStack {
        MarketChangeView(change: "+2.89")
        MarketChangeView(change: "-2.30")
        MarketChangeView(change: "0.00")
    }
}
