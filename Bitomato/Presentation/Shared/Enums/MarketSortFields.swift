enum MarketSortField {
    case name, volume, last, change
}

enum SortDirection {
    case ascending, descending, none

    mutating func toggle() {
        switch self {
        case .none: self = .descending
        case .descending: self = .ascending
        case .ascending: self = .none
        }
    }
}
