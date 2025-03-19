//
//  DepositViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//

import SwiftUI

@MainActor
class DepositViewModel: ObservableObject {
    // Liste complète des dépôts
    @Published var deposits: [Deposit] = []
    @Published var loading: Bool = false
    @Published var errorMessage: String?
    @Published var sessions: [Session] = []
    @Published var sellers: [Seller] = []
    @Published var games: [Game] = []

    private let depositService = DepositService.shared

    init() {
        Task { await fetchData() }
    }

    // MARK: - Fetch All Data
    func fetchData() async {
        loading = true
        do {
            async let fetchedSessions = SessionService.shared.getSessions()
            async let fetchedSellers = SellerService.shared.getSellers()
            async let fetchedGames = GameService.shared.getGames()
            async let fetchedDeposits = depositService.getAllDeposits()

            (sessions, sellers, games, deposits) = try await (fetchedSessions, fetchedSellers, fetchedGames, fetchedDeposits)
        } catch {
            errorMessage = "Erreur lors de la récupération des données : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Fetch Deposits
    func fetchDeposits() async {
        loading = true
        do {
            deposits = try await depositService.getAllDeposits()
        } catch {
            errorMessage = "Erreur lors de la récupération des dépôts : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Create Deposit
    func createDeposit(_ depositData: DepositCreate) async {
        loading = true
        do {
            _ = try await depositService.createDeposit(depositData)
            await fetchDeposits() // Recharge la liste
        } catch {
            errorMessage = "Erreur création dépôt : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Update Deposit (optionnel)
    func updateDeposit(id: Int, depositData: PartialDeposit) async {
        loading = true
        do {
            _ = try await depositService.updateDeposit(id, depositData)
            await fetchDeposits()
        } catch {
            errorMessage = "Erreur mise à jour dépôt : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Delete Deposit
    func deleteDeposit(id: Int) async {
        loading = true
        do {
            try await depositService.deleteDeposit(id)
            deposits.removeAll { $0.depositId == id } // Mise à jour locale
        } catch {
            errorMessage = "Erreur suppression dépôt : \(error.localizedDescription)"
        }
        loading = false
    }
}
