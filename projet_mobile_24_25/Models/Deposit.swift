//
//  Deposit.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Représente un dépôt (table: deposits).
struct Deposit: Codable, Identifiable {
    let depositId: Int
    var id: Int { depositId }

    let depositDate: Date
    let sellerId: Int
    let sessionId: Int
    let tag: String?
    let discountFees: Double?

    // Si tu veux récupérer l'association Seller ou Session côté Swift :
    // let Seller: Seller?
    // let Session: Session?
    // let DepositGames: [DepositGame]?

    enum CodingKeys: String, CodingKey {
        case depositId   = "deposit_id"
        case depositDate = "deposit_date"
        case sellerId    = "seller_id"
        case sessionId   = "session_id"
        case tag
        case discountFees = "discount_fees"
    }
}