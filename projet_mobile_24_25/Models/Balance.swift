//
//  Balance.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//

import Foundation

struct GlobalBalance: Codable{
    let sessionId: Int
    let totalDepositFees : Double
    let totalSales : Double
    let totalCommission: Double
    let totalBenef: Double
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case totalDepositFees = "total_deposit_fees"
        case totalSales = "total_sales"
        case totalCommission = "total_commission"
        case totalBenef = "total_benef"
    }
}
