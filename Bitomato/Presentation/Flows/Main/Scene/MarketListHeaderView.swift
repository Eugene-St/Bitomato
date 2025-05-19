import SwiftUI

struct MarketListHeaderView: View {
    let currentSort: MarketSortField
    let direction: SortDirection
    let onSort: (MarketSortField) -> Void

    var body: some View {
        HStack {
            sortButton(title: "Name", field: .name)
            sortButton(title: "Vol", field: .volume)
            Spacer()
            sortButton(title: "Last", field: .last)
            sortButton(title: "24H Change", field: .change)
        }
        .font(.caption)
        .foregroundColor(.gray)
        .padding(.horizontal, 10)
    }

    private func sortButton(title: String, field: MarketSortField) -> some View {
        Button(action: { onSort(field) }) {
            HStack(spacing: 4) {
                Text(title)
                if currentSort == field {
                    Image(systemName: direction == .ascending ? "arrow.up" : direction == .descending ? "arrow.down" : "")
                        .font(.system(size: 10, weight: .bold))
                }
            }
        }
    }
}

#Preview {
    MarketListHeaderView(
        currentSort: .name,
        direction: .descending,
        onSort: { _ in }
    )
}
