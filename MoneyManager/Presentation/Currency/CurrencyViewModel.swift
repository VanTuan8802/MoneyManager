//
//  CurrencyViewModel.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import Foundation
import Combine

final class CurrencyViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var renderCurrencies: [Currency] = []
    @Published var searchText: String = ""
    @Published var currencySelected: Currency = .default()
    
    var isFullScreen = false

    init(isFullScreen: Bool,
         currencySelected: Currency) {
        self.isFullScreen = isFullScreen
        self.currencySelected = currencySelected

        if CurrencyManager.shared.currencies.isEmpty {
            CurrencyManager.shared.getCurrency()
        }
        
        let results = CurrencyManager.shared.currencies
        currencies = results
        renderCurrencies = currencies
    }

    func search(with text: String) {
        updateReder(with: text)
    }

    private func updateReder(with text: String) {
        guard !text.isEmpty else {
            renderCurrencies = currencies
            return
        }

        renderCurrencies = currencies.filter { $0.code.lowercased().contains(text.lowercased()) }
    }
}
