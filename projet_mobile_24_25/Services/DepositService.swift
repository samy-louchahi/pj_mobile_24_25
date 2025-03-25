//
//  DepositCreate.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import Foundation
import Combine

// MARK: - Models

// Pour créer un dépôt, on envoie les informations suivantes :
struct DepositCreate: Codable {
    let seller_id: Int
    let session_id: Int
    let deposit_date: String // Par exemple en format ISO8601 "YYYY-MM-DD"
    let discount_fees: Double?
    let games: [DepositGameCreate]
}

// Pour chaque jeu déposé dans le dépôt
struct DepositGameCreate: Codable {
    let game_id: Int
    let quantity: Int
    let exemplaires: [String: Exemplaire] // Par exemple: "0": { price: 10.0, state: "neuf" }
}


// Pour les mises à jour partielles (si nécessaire)
struct PartialDeposit: Codable {
    let deposit_date: String?
    let discount_fees: Double?
    // Ajoute d'autres champs si nécessaire
}


// MARK: - Service

class DepositService {
    static let shared = DepositService()
    private let apiService = APIService()

    /// Récupérer la liste de tous les dépôts
    func getAllDeposits() async throws -> [Deposit] {
        return try await apiService.get("/deposits")
    }

    /// Récupérer tous les jeux déposés
    func getAllDepositGames() async throws -> [DepositGame] {
        return try await apiService.get("/depositGames")
    }

    /// Créer un dépôt avec ses jeux associés
    func createDeposit(_ depositData: DepositCreate) async throws -> Deposit {
        return try await apiService.post("/deposits", body: depositData)
    }

    /// Mettre à jour un dépôt
    func updateDeposit(_ id: Int, _ depositData: PartialDeposit) async throws -> Deposit {
        return try await apiService.put("/deposits/\(id)", body: depositData)
    }

    /// Supprimer un dépôt
    func deleteDeposit(_ id: Int) async throws {
        try await apiService.delete("/deposits/\(id)")
    }
}
