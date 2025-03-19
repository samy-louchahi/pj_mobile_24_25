//
//  SaleDetail.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

struct SaleDetail: Codable, Identifiable {
    let saleDetailId: Int
    var id: Int { saleDetailId }

    let saleId: Int
    let sellerId: Int
    let depositGameId: Int
    let quantity: Int

    // 🔹 Relations
    var sale: Sale?
    var depositGame: DepositGame?
    var seller: Seller?

    enum CodingKeys: String, CodingKey {
        case saleDetailId = "sale_detail_id"
        case saleId = "sale_id"
        case sellerId = "seller_id"
        case depositGameId = "deposit_game_id"
        case quantity
        case sale = "Sale"
        case depositGame = "DepositGame"
        case seller = "Seller"
    }
}
