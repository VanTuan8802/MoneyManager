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
    @Published var favorites: [Currency] = []
    @Published var renderFavorites: [Currency] = []
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
        
        let favoriteIds = CurrencyStorage.shared.favorites

        let results = CurrencyManager.shared.currencies
        for currency in results {
            if favoriteIds.contains(currency.id) {
                favorites.append(currency)
            } else {
                currencies.append(currency)
            }
        }
        renderCurrencies = currencies
        renderFavorites = favorites
    }

    func favoriteToggled(_ currency: Currency) {
        guard let index = currencies.firstIndex(of: currency) else {
            return
        }

        currencies.remove(at: index)
        favorites.append(currency)
        CurrencyStorage.shared.favorites.append(currency.id)
        updateReder(with: searchText)
    }

    func unfavoriteToggled(_ currency: Currency) {
        guard let index = favorites.firstIndex(of: currency) else {
            return
        }

        favorites.remove(at: index)
        currencies.append(currency)
        CurrencyStorage.shared.favorites.removeAll(where: { $0 == currency.id })
        updateReder(with: searchText)
    }

    func search(with text: String) {
        updateReder(with: text)
    }

    private func updateReder(with text: String) {
        guard !text.isEmpty else {
            renderCurrencies = currencies
            renderFavorites = favorites
            return
        }

        renderCurrencies = currencies.filter { $0.code.lowercased().contains(text.lowercased()) }
        renderFavorites = favorites.filter { $0.code.lowercased().contains(text.lowercased()) }
    }
}
