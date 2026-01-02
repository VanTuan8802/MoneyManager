//
//  SetBudgetViewModel.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 2/1/26.
//

import Foundation
import Combine

final class SetBudgetViewModel: ObservableObject {
    @Published var budget: String = "" {
        didSet {
            updateIsEnable()
        }
    }
    
    @Published var isEnable: Bool = false
    
    private func updateIsEnable() {
        let amount = budget.toDouble(locale: Locale.current)
        isEnable = amount > 0
    }
}
