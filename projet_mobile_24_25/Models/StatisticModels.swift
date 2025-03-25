//
//  GlobalBalanceResponse.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


// StatisticsModels.swift

import Foundation

struct GlobalBalance: Codable {
    let session_id: Int
    let totalSales: Double
    let totalDepositFees: Double
    let totalCommission: Double
    let totalBenef: Double
    
}

struct GlobalBalanceResponse: Codable {
    let session_id: Int
    let totalSales: Double
    let totalDepositFees: Double
    let totalCommission: Double
    let totalBenef: Double
}

struct SalesOverTimeData: Codable {
    let date: String
    let total: Double
}

struct TopGame: Codable {
    let gameName: String
    let publisher: String
    let totalQuantity: Int
    let totalAmount: Double
}

struct VendorShare: Codable {
    let seller_id: Int
    let sellerName: String
    let total: Double
}

struct VendorStatsResponse: Codable {
    let totalVendors: Int
    let topVendor: TopVendor
}

struct TopVendor: Codable {
    let sellerName: String
    let totalSales: Int
}
