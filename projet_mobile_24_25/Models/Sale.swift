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

    let buyerId: Int?
    let sessionId: Int
    let saleStatus: SaleStatus
    let saleDate: Date

    // 🔹 Relations
    var buyer: Buyer?
    var session: Session?
    var saleDetails: [SaleDetail]?
    var salesOperation: SalesOperation? 

    enum CodingKeys: String, CodingKey {
        case saleId = "sale_id"
        case buyerId = "buyer_id"
        case sessionId = "session_id"
        case saleStatus = "sale_status"
        case saleDate = "sale_date"
        case buyer = "Buyer"
        case session = "Session"
        case saleDetails = "SaleDetails"
        case salesOperation = "SalesOperation"
    }
}
