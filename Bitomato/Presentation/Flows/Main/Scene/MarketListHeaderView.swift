import SwiftUI

struct MarketListHeaderView: View {
    let currentSort: MarketSortField
    let direction: SortDirection
    let onSort: (MarketSortField) -> Void

    var body: some View {
        HStack(spacing: 20) {
            sortButton(title: "Name", field: .name)
            sortButton(title: "Vol", field: .volume)
            Spacer()
            sortButton(title: "Last", field: .last)
            sortButton(title: "24H Change", field: .change)
        }
        .font(.caption)
        .foregroundColor(.interfaceGrey)
        .padding(.horizontal, 10)
    }

    private func sortButton(title: String, field: MarketSortField) -> some View {
        Button(action: {
            onSort(field)
        }) {
            HStack(spacing: 4) {
                Text(title)

                VStack(spacing: 1) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(currentSort == field && direction == .ascending ? .interfaceBlack : .interfaceGrey)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(currentSort == field && direction == .descending ? .interfaceBlack : .interfaceGrey)
                }
            }
        }
    }
}

#Preview {
    MarketListHeaderView(
        currentSort: .volume,
        direction: .ascending,
        onSort: { _ in }
    )
    .padding()
    .background(Color.white)
}
