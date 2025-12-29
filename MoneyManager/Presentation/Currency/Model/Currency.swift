//
//  Currency.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 29/12/25.
//

import Foundation

class Currency: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let code: String
    let flag: String
    let country: String
    let currency: String
    let symbol: String
    let identifier: String

    init(id: Int,
         code: String,
         flag: String,
         country: String,
         currency: String,
         symbol: String,
         identifier: String) {
        self.id = id
        self.code = code
        self.flag = flag
        self.country = country
        self.currency = currency
        self.symbol = symbol
        self.identifier = identifier
    }

    static func == (lhs: Currency, rhs: Currency) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func codeAndSymbol() -> String {
        "\(code) \(symbol)"
    }

    static func `default`() -> Currency {
        return Currency(id: 152,
                        code: "USD",
                        flag: "https://144-202-123-28.nip.io/images/unitedstates.png",
                        country: "United States",
                        currency: "Dollar",
                        symbol: "$",
                        identifier: "en_US")
    }
}

