//
//  Buyer.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Représente un acheteur (table: buyers).
struct Buyer: Codable, Identifiable {
    /// buyer_id -> id pour Identifiable
    let buyerId: Int
    var id: Int { buyerId }

    let name: String
    let email: String
    let phone: String?
    let address: String?

    enum CodingKeys: String, CodingKey {
        case buyerId = "buyer_id"
        case name
        case email
        case phone
        case address
    }
}