import SwiftUI

enum Destination: Equatable {
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
    case home
    case statistics
    case budget
    case setting
    case addTransaction
}

extension Destination {
    var identifier: String {
        switch self {
        case .home: return "home"
        case .statistics: return "statistics"
        case .budget: return "budget"
        case .setting: return "setting"
        case .addTransaction: return "addTransaction"
        }
    }
}

extension Navigation {
    @ViewBuilder
    internal func screen(for destinationWrapper: DestinationWrapper) -> some View {
        switch destinationWrapper.destination {
        case .home:
            HomeView()
        case .statistics:
            StatisticView()
        case .budget:
            BudgetView()
        case .setting:
            SettingView()
        case .addTransaction:
            AddTransactionView()
        }
    }
}
