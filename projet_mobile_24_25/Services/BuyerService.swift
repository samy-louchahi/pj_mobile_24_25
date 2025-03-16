//
//  BuyerService.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import Foundation
import Combine

class BuyerService {
    static let shared = BuyerService()
    private let apiService = APIService()  // Ton service générique

    func getBuyers() -> AnyPublisher<[Buyer], APIError> {
        apiService.get("/buyers") // => renvoie AnyPublisher<[Buyer], APIError>
    }

    func createBuyer(_ newBuyer: BuyerCreate) -> AnyPublisher<Buyer, APIError> {
        apiService.post("/buyers", body: newBuyer)
    }

    func updateBuyer(_ id: Int, _ updatedBuyer: BuyerCreate) -> AnyPublisher<Buyer, APIError> {
        apiService.put("/buyers/\(id)", body: updatedBuyer)
    }

    func deleteBuyer(_ id: Int) -> AnyPublisher<Void, APIError> {
        apiService.delete("/buyers/\(id)") // => AnyPublisher<Void, APIError>
    }
}

// Représente le payload pour la création / mise à jour
struct BuyerCreate: Codable {
    let name: String
    let email: String
    let phone: String
    let address: String
}
