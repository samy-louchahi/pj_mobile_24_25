//
//  Seller.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Représente un vendeur (table: sellers).
struct Seller: Codable, Identifiable {
    let sellerId: Int
    var id: Int { sellerId }

    let name: String?
    let email: String?
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case sellerId = "seller_id"
        case name
        case email
        case phone
    }
}