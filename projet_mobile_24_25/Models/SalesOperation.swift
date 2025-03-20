//
//  SalesOpStatus.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation

enum SalesOpStatus: String, Codable, CaseIterable, DateCodable {
    case enCours  = "en cours"
    case finalise = "finalisé"
    case annule   = "annulé"
}

struct SalesOperation: Codable, Identifiable {
    let salesOpId: Int
    var id: Int { salesOpId }

    let saleId: Int
    let commission: Double
    let saleDate: String
    let saleStatus: SalesOpStatus

    enum CodingKeys: String, CodingKey {
        case salesOpId  = "sales_op_id"
        case saleId     = "sale_id"
        case commission
        case saleDate   = "sale_date"
        case saleStatus = "sale_status"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.salesOpId = try container.decode(Int.self, forKey: .salesOpId)
        self.saleId = try container.decode(Int.self, forKey: .saleId)
        self.commission = try container.decode(Double.self, forKey: .commission)
        self.saleDate = try container.decode(String.self, forKey: .saleDate)
        self.saleStatus = try container.decode(SalesOpStatus.self, forKey: .saleStatus)
    }
}
