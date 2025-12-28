import SwiftUI

enum Destination: Equatable {
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
    case home
}

extension Destination {
    var identifier: String {
        switch self {
        case .home: return "home"
      
        }
    }
}

extension Navigation {
    @ViewBuilder
    internal func screen(for destinationWrapper: DestinationWrapper) -> some View {
        switch destinationWrapper.destination {
        case .home:
            HomeView()
        }
    }
}
