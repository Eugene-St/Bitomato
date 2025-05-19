import SwiftUI

protocol Coordinator: ObservableObject {
    var path: NavigationPath { get set }
}
