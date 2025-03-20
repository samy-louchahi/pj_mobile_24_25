//
//  JsonDecoderDate.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 20/03/2025.
//

import Foundation

extension JSONDecoder {
    static var customISO8601Decoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        // Création d’un DateFormatter personnalisé
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" // Format complet ISO8601
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}
