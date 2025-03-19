//
//  SellerService.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation
import Combine

/// Service dédié aux opérations CRUD sur les Sellers.
class SellerService {
    static let shared = SellerService()
    
    /// Le service d’API générique
    private let apiService = APIService()

    // MARK: - GET all Sellers
    func getSellers() async throws -> [Seller] {
        return try await apiService.get("/sellers")
    }

    // MARK: - CREATE Seller
    func createSeller(_ newSeller: SellerCreate) async throws -> Seller {
        return try await apiService.post("/sellers", body: newSeller)
    }

    // MARK: - UPDATE Seller
    func updateSeller(_ id: Int, _ updatedSeller: SellerCreate) async throws -> Seller {
        return try await apiService.put("/sellers/\(id)", body: updatedSeller)
    }

    // MARK: - DELETE Seller
    func deleteSeller(_ id: Int) async throws {
        try await apiService.delete("/sellers/\(id)")
    }

    // MARK: - Exemple si tu veux récupérer d’autres infos (Stocks, Ventes, Bilans, etc.)
    // func getSellerStocks(_ sellerId: Int) async throws -> [Stock] {
    //     return try await apiService.get("/sellers/\(sellerId)/stocks")
    // }
    
    // func getSellerDetails(...) async throws -> SellerDetails { ... }
}

/// Payload pour la création / mise à jour (correspond à { name, email, phone } côté backend)
struct SellerCreate: Codable {
    let name: String
    let email: String
    let phone: String
}
