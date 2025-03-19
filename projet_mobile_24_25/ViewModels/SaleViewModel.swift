//
//  SaleViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//

import SwiftUI

@MainActor
class SaleViewModel: ObservableObject {
    @Published var sales: [Sale] = []
    @Published var buyers: [Buyer] = []
    @Published var sellers: [Seller] = []
    @Published var sessions: [Session] = []
    @Published var activeSession: Session?
    @Published var deposits: [Deposit] = []
    @Published var depositGames: [DepositGame] = []
    
    @Published var loading: Bool = false
    @Published var errorMessage: String?

    private let saleService = SaleService.shared
    private let buyerService = BuyerService.shared
    private let sellerService = SellerService.shared
    private let sessionService = SessionService.shared
    private let depositService = DepositService.shared

    init() {
        Task { await fetchInitialData() }
    }

    // MARK: - Fetch Initial Data
    func fetchInitialData() async {
        do {
            loading = true

            // Exécution des requêtes en parallèle
            async let buyersResult = buyerService.getBuyers()
            async let sellersResult = sellerService.getSellers()
            async let sessionsResult = sessionService.getSessions()
            async let depositsResult = depositService.getAllDeposits()
            async let depositGamesResult = depositService.getAllDepositGames()

            buyers = try await buyersResult
            sellers = try await sellersResult
            sessions = try await sessionsResult
            deposits = try await depositsResult
            depositGames = try await depositGamesResult

            // Trouver la session active
            activeSession = sessions.first(where: { $0.status })

        } catch {
            errorMessage = "Erreur lors de la récupération des données : \(error.localizedDescription)"
        }
        loading = false
    }
    
    // MARK: - Fetch Sales
    func fetchSales() async {
        do {
            loading = true
            sales = try await saleService.getAllSales()
        } catch {
            errorMessage = "Erreur lors de la récupération des ventes : \(error.localizedDescription)"
        }
        loading = false
    }
    
    // MARK: - Create Sale
    func createSale(_ saleData: SaleCreate) async {
        do {
            loading = true
            _ = try await saleService.createSale(saleData)
            await fetchSales()
        } catch {
            errorMessage = "Erreur création vente : \(error.localizedDescription)"
        }
        loading = false
    }
    
    // MARK: - Update Sale
    func updateSale(id: Int, saleData: PartialSale) async {
        do {
            loading = true
            _ = try await saleService.updateSale(id, saleData: saleData)
            await fetchSales()
        } catch {
            errorMessage = "Erreur mise à jour vente : \(error.localizedDescription)"
        }
        loading = false
    }
    
    // MARK: - Delete Sale
    func deleteSale(id: Int) async {
        do {
            loading = true
            try await saleService.deleteSale(id)
            sales.removeAll { $0.saleId == id }
        } catch {
            errorMessage = "Erreur suppression vente : \(error.localizedDescription)"
        }
        loading = false
    }
}
