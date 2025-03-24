//
//  StatisticViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


// StatisticViewModel.swift

import Foundation

@MainActor
class StatisticViewModel: ObservableObject {
    @Published var globalBalance: GlobalBalanceResponse?
    @Published var salesOverTime: [SalesOverTimeData] = []
    @Published var topGames: [TopGame] = []
    @Published var vendorShares: [VendorShare] = []
    @Published var vendorStats: VendorStatsResponse?
    @Published var salesCount: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = StatisticService.shared

    func fetchAll(for sessionId: Int) async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let balance = service.getGlobalBalance(for: sessionId)
            async let sales = service.getSalesOverTime(for: sessionId)
            async let count = service.getSalesCount(for: sessionId)
            async let top = service.getTopGames(for: sessionId)
            async let shares = service.getVendorShares(for: sessionId)
            async let stats = service.getVendorStats(for: sessionId)

            self.globalBalance = try await balance
            self.salesOverTime = try await sales
            self.salesCount = try await count
            self.topGames = try await top
            self.vendorShares = try await shares
            self.vendorStats = try await stats
        } catch {
            print("❌ Erreur stats API :", error)
            errorMessage = "Erreur de chargement des statistiques : \(error.localizedDescription)"
        }
    }
}
