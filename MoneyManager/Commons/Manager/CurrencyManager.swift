//
//  CurrencyManager.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import Foundation

func getCurrency(id: Int) -> Currency {
    return CurrencyManager.shared.currencies.first(where: { $0.id == id }) ?? .default()
}

class CurrencyManager {

    static let shared = CurrencyManager()

    var currencies: [Currency] = []

    func getCurrency() {
        do {
            let result: [Currency] = try CurrencyManager.shared.load(
               "currency", bundle: .main
            )
            currencies = result
        } catch {
            print("❌ Error loading currencies:", error.localizedDescription)
        }
    }

    private func load<T: Decodable>(_ filename: String,
                                    bundle: Bundle = .main) throws -> T {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "LoadJSON", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Could not find the file \(filename).json in the provided bundle."
            ])
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
