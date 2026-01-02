//
//  TabBarItem.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 2/1/26.
//


import Foundation
import SwiftUI

enum TabBarItem: Int, Identifiable, CaseIterable, Comparable {

    internal var id: Int { rawValue }

    static func < (lhs: TabBarItem, rhs: TabBarItem) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case home
    case statistic
    case budget
    case setting

    var title: String {
        switch self {
        case .home:
            return String(localized: .home)
        case .statistic:
            return String(localized: .statistics)
        case .budget:
            return String(localized: .budget)
        case .setting:
            return String(localized: .setting)
        }
    }

    var iconNormal: Image {
        switch self {
        case .home:
            return Image(.homeNormal)
        case .statistic:
            return Image(.statisticsNormal)
        case .budget:
            return Image(.budgetNormal)
        case .setting:
            return Image(.settingNormal)
        }
    }
    
    var iconSelected: Image {
        switch self {
        case .home:
            return Image(.homeActive)
        case .statistic:
            return Image(.statisticsActive)
        case .budget:
            return Image(.budgetActive)
        case .setting:
            return Image(.settingActive)
        }
    }

    var color: Color {
        switch self {
        case .home:
            return .indigo
        case .statistic:
            return .pink
        case .budget:
            return .orange
        case .setting:
            return .teal
        }
    }
}
