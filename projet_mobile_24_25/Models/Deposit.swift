//
//  Deposit.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Représente un dépôt (table: deposits).
struct Deposit: Codable, Identifiable, DateCodable {
    let depositId: Int
    var id: Int { depositId }

    let depositDate: Date
    let sellerId: Int
    let sessionId: Int
    let tag: String?
    let discountFees: Double?

    var seller: Seller?
    // let Session: Session?
     var depositGames: [DepositGame]?

    enum CodingKeys: String, CodingKey {
        case depositId   = "deposit_id"
        case depositDate = "deposit_date"
        case sellerId    = "seller_id"
        case sessionId   = "session_id"
        case tag
        case discountFees = "discount_fees"
        case seller = "Seller"
        case depositGames = "DepositGames"
    }
}
