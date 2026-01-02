//
//  String+.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 2/1/26.
//

import Foundation
import CryptoKit

var numberFormatter: NumberFormatter = {
    var numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 2
    numberFormatter.minimumFractionDigits = 0
    numberFormatter.groupingSize = 3
    numberFormatter.groupingSeparator = ","
    numberFormatter.decimalSeparator = "."
    numberFormatter.usesGroupingSeparator = true
    
    return numberFormatter
}()

extension String {
    func toCurrency(locale: Locale) -> String {
        guard !self.isEmpty else { return self }
        
        let groupingSeparator = locale.groupingSeparator ?? ","
        let cleanString = self.replacingOccurrences(of: groupingSeparator, with: "")
        
        let decimalSeparator = locale.decimalSeparator ?? "."
        let amountArray = cleanString.components(separatedBy: decimalSeparator)
        
        let amountLeft = amountArray[0]
        let amountLeftValue = Double(amountLeft) ?? 0
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        let formattedLeft = formatter.string(from: NSNumber(value: amountLeftValue)) ?? "0"
        
        if amountArray.count > 1 {
            let amountRight = String(amountArray[1].prefix(2))
            return "\(formattedLeft)\(decimalSeparator)\(amountRight)"
        } else {
            return formattedLeft
        }
    }
    
    func toDouble(locale: Locale) -> Double {
        guard !self.isEmpty else { return 0.0 }
        
        let groupingSeparator = locale.groupingSeparator ?? ","
        let decimalSeparator = locale.decimalSeparator ?? "."
        
        var cleanString = self.replacingOccurrences(of: groupingSeparator, with: "")
        
        if decimalSeparator != "." {
            cleanString = cleanString.replacingOccurrences(of: decimalSeparator, with: ".")
        }
        
        return Double(cleanString) ?? 0.0
    }
}

extension String {
    static let zero = "0"
}

extension String {
    func toInt() -> Int {
        return Int(self) ?? 0
    }
}

extension String {
    func monthNumber() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM"
        
        if let date = dateFormatter.date(from: self) {
            return Calendar.current.component(.month, from: date)
        }
        return nil
    }
}

extension String {
    static let empty = ""
}

extension String {
    func toNSNumber() -> NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
}

extension String {
    func toDateAsddMMyy() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }
    
    func uuidFromFirebaseUID() -> UUID {
        let hash = Insecure.SHA1.hash(data: Data(self.utf8))
        let uuidBytes = Array(hash.prefix(16))
        
        let uuidTuple: uuid_t = (
            uuidBytes[0], uuidBytes[1], uuidBytes[2], uuidBytes[3],
            uuidBytes[4], uuidBytes[5], uuidBytes[6], uuidBytes[7],
            uuidBytes[8], uuidBytes[9], uuidBytes[10], uuidBytes[11],
            uuidBytes[12], uuidBytes[13], uuidBytes[14], uuidBytes[15]
        )
        
        return UUID(uuid: uuidTuple)
    }
}
