import SwiftUI

struct TabPickerView: View {
    let tabs: [String]
    let selected: String
    let onSelect: (String) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                VStack(spacing: 4) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            onSelect(tab)
                        }
                    }) {
                        Text(tab)
                            .font(.subheadline)
                            .foregroundColor(selected == tab ? .interfaceBlack : .interfaceGrey)
                    }

                    Rectangle()
                        .fill(selected == tab ? .accentGreen : .lightGrey)
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .animation(.easeInOut(duration: 0.2), value: selected)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    StatefulPreviewWrapper("BTC") { selectedTab in
        TabPickerView(
            tabs: ["USD", "BTC", "ALTS", "DEFI"],
            selected: selectedTab.wrappedValue,
            onSelect: { selectedTab.wrappedValue = $0 }
        )
    }
}
