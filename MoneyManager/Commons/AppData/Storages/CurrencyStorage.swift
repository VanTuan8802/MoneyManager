//
//  CurrencyStorage.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import Foundation
import SwiftUI

class CurrencyStorage {

    static let shared = CurrencyStorage()

    private enum Key: String {
        case favorites
    }

    @AppStorage(Key.favorites.rawValue)
    private var favoritesData: Data = Data()

    var favorites: [Int] {
        get {
            (try? JSONDecoder().decode([Int].self, from: favoritesData)) ?? []
        }
        set {
            favoritesData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
}
