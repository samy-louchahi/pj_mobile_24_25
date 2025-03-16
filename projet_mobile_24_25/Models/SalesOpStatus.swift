//
//  SalesOpStatus.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

/// Reprend le même type SaleStatus si tu le souhaites,  
/// ou en crée un deuxième si tu veux des nuances différentes.
enum SalesOpStatus: String, Codable {
    case enCours  = "en cours"
    case finalise = "finalisé"
    case annule   = "annulé"
}

/// Représente une opération associée à une vente (table: sale_operations).
struct SalesOperation: Codable, Identifiable {
    let salesOpId: Int
    var id: Int { salesOpId }

    let saleId: Int
    let commission: Double
    let saleDate: Date
    let saleStatus: SalesOpStatus

    enum CodingKeys: String, CodingKey {
        case salesOpId  = "sales_op_id"
        case saleId     = "sale_id"
        case commission
        case saleDate   = "sale_date"
        case saleStatus = "sale_status"
    }
}