//
//  DateCodable.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 20/03/2025.
//


import Foundation

protocol DateCodable: Codable {
    var dateFormatter: DateFormatter { get }
}

extension DateCodable {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // Format ISO8601
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
}