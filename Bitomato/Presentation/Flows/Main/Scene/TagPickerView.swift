import SwiftUI

struct TagPickerView: View {
    let tags: [String]
    let selected: String?
    let onSelect: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            onSelect(tag)
                        }
                    }) {
                        Text(tag)
                            .font(.subheadline)
                            .foregroundColor(selected == tag ? .interfaceBlack : .interfaceGrey)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.gray.opacity(0.15))
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

