//
//  BuyerService.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//

import Foundation

class BuyerService {
    static let shared = BuyerService()
    private let apiService = APIService()  // Ton service générique

    // Récupérer tous les acheteurs
    func getBuyers() async throws -> [Buyer] {
        return try await apiService.get("/buyers")
    }

    // Créer un acheteur
    func createBuyer(_ newBuyer: BuyerCreate) async throws -> Buyer {
        return try await apiService.post("/buyers", body: newBuyer)
    }

    // Mettre à jour un acheteur
    func updateBuyer(_ id: Int, _ updatedBuyer: BuyerCreate) async throws -> Buyer {
        return try await apiService.put("/buyers/\(id)", body: updatedBuyer)
    }

    // Supprimer un acheteur
    func deleteBuyer(_ id: Int) async throws {
        try await apiService.delete("/buyers/\(id)")
    }
}

// Représente le payload pour la création / mise à jour
struct BuyerCreate: Codable {
    let name: String
    let email: String
    let phone: String
    let address: String
}
