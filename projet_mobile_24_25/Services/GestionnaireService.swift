//
//  GestionnaireService.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 22/03/2025.
//


import Foundation

class GestionnaireService {
    static let shared = GestionnaireService()
    private let api = APIService()

    // Récupérer tous les gestionnaires
    func getGestionnaires() async throws -> [Gestionnaire] {
        return try await api.get("/gestionnaires")
    }

    // Créer un gestionnaire
    func createGestionnaire(_ data: GestionnaireCreate) async throws -> Gestionnaire {
        return try await api.post("/gestionnaires", body: data)
    }

    // Mettre à jour un gestionnaire
    func updateGestionnaire(id: Int, _ data: PartialGestionnaire) async throws -> Gestionnaire {
        return try await api.put("/gestionnaires/\(id)", body: data)
    }

    // Supprimer un gestionnaire
    func deleteGestionnaire(id: Int) async throws {
        try await api.delete("/gestionnaires/\(id)")
    }
}
