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
    
    /// Le service d’API générique qui gère les appels réseau (token, etc.)
    private let apiService = APIService()

    // MARK: - GET all Sellers
    func getSellers() -> AnyPublisher<[Seller], APIError> {
        apiService.get("/sellers")  // => attend un Array<Seller> en réponse
    }

    // MARK: - CREATE Seller
    func createSeller(_ newSeller: SellerCreate) -> AnyPublisher<Seller, APIError> {
        /// POST /sellers => renvoie l’objet Seller créé (si ton backend fait cela)
        apiService.post("/sellers", body: newSeller)
    }

    // MARK: - UPDATE Seller
    func updateSeller(_ id: Int, _ updatedSeller: SellerCreate) -> AnyPublisher<Seller, APIError> {
        /// PUT /sellers/:id => renvoie l’objet Seller mis à jour
        apiService.put("/sellers/\(id)", body: updatedSeller)
    }

    // MARK: - DELETE Seller
    func deleteSeller(_ id: Int) -> AnyPublisher<Void, APIError> {
        /// DELETE /sellers/:id => renvoie (en général) rien ou { message: ... }
        apiService.delete("/sellers/\(id)")
    }

    // MARK: - Exemple si tu veux récupérer d’autres infos (Stocks, Ventes, Bilans, etc.)
    // func getSellerStocks(_ sellerId: Int) -> AnyPublisher<[Stock], APIError> {
    //     apiService.get("/sellers/\(sellerId)/stocks")
    // }
    
    // func getSellerDetails(...) ...
}

/// Payload pour la création / mise à jour (correspond à { name, email, phone } côté backend)
struct SellerCreate: Codable {
    let name: String
    let email: String
    let phone: String
}
