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
    
    /// Récupère la liste de tous les dépôts
    func getAllDeposits() -> AnyPublisher<[Deposit], APIError> {
        apiService.get("/deposits")
    }
    
    /// Crée un nouveau dépôt avec ses jeux associés
    func createDeposit(_ depositData: DepositCreate) -> AnyPublisher<Deposit, APIError> {
        apiService.post("/deposits", body: depositData)
    }
    
    /// Met à jour un dépôt (optionnel)
    func updateDeposit(_ id: Int, _ depositData: PartialDeposit) -> AnyPublisher<Deposit, APIError> {
        apiService.put("/deposits/\(id)", body: depositData)
    }
    
    /// Supprime un dépôt
    func deleteDeposit(_ id: Int) -> AnyPublisher<Void, APIError> {
        apiService.delete("/deposits/\(id)")
    }
}
