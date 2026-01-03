//
//  BudgetStorage.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 3/1/26.
//

import Foundation
import SwiftUI

class BudgetStorage {

    static let shared = BudgetStorage()

    private enum Key: String {
        case budget
    }

    @AppStorage(Key.budget.rawValue)
    var budget: Double = 0
}

