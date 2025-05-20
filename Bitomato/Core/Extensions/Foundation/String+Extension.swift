extension String {
    func formatPriceWithSpaces() -> String {
        let clean = self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: "")
        let parts = clean.split(separator: ".")
        let integerPart = parts.first ?? ""
        let fractionalPart = parts.count > 1 ? parts[1] : ""
        let groupedFraction = stride(from: 0, to: fractionalPart.count, by: 3).map { index in
            let start = fractionalPart.index(fractionalPart.startIndex, offsetBy: index)
            let end = fractionalPart.index(start, offsetBy: 3, limitedBy: fractionalPart.endIndex) ?? fractionalPart.endIndex
            return String(fractionalPart[start..<end])
        }.joined(separator: " ")
        
        return integerPart.isEmpty ? "0.\(groupedFraction)" : "\(integerPart).\(groupedFraction)"
    }
}
