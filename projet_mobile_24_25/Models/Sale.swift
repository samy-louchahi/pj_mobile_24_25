//
//  Sale.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

struct Sale: Codable, Identifiable {
    let saleId: Int
    var id: Int { saleId }

    let buyerId: Int?       // Peut être null
    let sessionId: Int
    let saleStatus: SaleStatus
    let saleDate: Date

    enum CodingKeys: String, CodingKey {
        case saleId     = "sale_id"
        case buyerId    = "buyer_id"
        case sessionId  = "session_id"
        case saleStatus = "sale_status"
        case saleDate   = "sale_date"
    }
}