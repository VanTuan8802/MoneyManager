//
//  AppManager.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 28/12/25.
//


import Foundation
import Combine

@MainActor
class AppManager: ObservableObject {
    /// Tabbar
    @Published var isShowTabbar: Bool = true
    @Published var activeTab: TabBarItem = .home

    /// Navi
    @Published var navi: Navigation = Navigation()

    /// State
    @Published var isInBackground: Bool = false
}
