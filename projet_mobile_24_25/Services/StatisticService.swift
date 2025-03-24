//
//  StatisticService.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


// StatisticService.swift

import Foundation

class StatisticService {
    static let shared = StatisticService()
    private let apiService = APIService()
    private init() {}

    func getGlobalBalance(for sessionId: Int) async throws -> GlobalBalanceResponse {
        return try await apiService.get("/finances/session/\(sessionId)")
    }

    func getSalesOverTime(for sessionId: Int) async throws -> [SalesOverTimeData] {
        return try await apiService.get("/statistics/session/\(sessionId)/salesovertime")
    }

    func getSalesCount(for sessionId: Int) async throws -> Int {
        struct Response: Codable { let salesCount: Int }
        let result: Response = try await apiService.get("/statistics/session/\(sessionId)/salescount")
        return result.salesCount
    }

    func getTopGames(for sessionId: Int) async throws -> [TopGame] {
        return try await apiService.get("/statistics/session/\(sessionId)/top-games")
    }

    func getVendorShares(for sessionId: Int) async throws -> [VendorShare] {
        return try await apiService.get("/statistics/sessions/vendorshares/\(sessionId)")
    }

    func getVendorStats(for sessionId: Int) async throws -> VendorStatsResponse {
        return try await apiService.get("/statistics/session/\(sessionId)/vendor-stats")
    }
}
