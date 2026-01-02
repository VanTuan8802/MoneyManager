//
//  Container+.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 28/12/25.
//

import Foundation
import Factory

/// App manager
extension Container {
    var app: Factory<AppManager> {
        Factory(self) { @MainActor in
            AppManager()
        }.singleton
    }
}

/// Navigation
extension Container {
    var homeNavi: Factory<Navigation> {
        Factory(self) { @MainActor in
            Navigation()
        }.singleton
    }
    
    var statistics: Factory<Navigation> {
        Factory(self) { @MainActor in
            Navigation()
        }.singleton
    }
    
    var budget: Factory<Navigation> {
        Factory(self) { @MainActor in
            Navigation()
        }.singleton
    }
    
    var setting: Factory<Navigation> {
        Factory(self) { @MainActor in
            Navigation()
        }.singleton
    }
}

/// Tabbar
extension Container {
    var dataRefresh: Factory<DataFreshable> {
        Factory(self) { @MainActor in
            DataFreshable()
        }.singleton
    }
}
