//
//  GestionnaireViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 22/03/2025.
//


import Foundation

@MainActor
class GestionnaireViewModel: ObservableObject {
    @Published var gestionnaires: [Gestionnaire] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private let service = GestionnaireService.shared

    func fetchGestionnaires() async {
        do {
            isLoading = true
            self.gestionnaires = try await service.getGestionnaires()
        } catch {
            self.errorMessage = "Erreur de chargement : \(error.localizedDescription)"
        }
        isLoading = false
    }

    func createGestionnaire(_ data: GestionnaireCreate) async {
        do {
            try await service.createGestionnaire(data)
            await fetchGestionnaires()
        } catch {
            errorMessage = "Erreur création : \(error.localizedDescription)"
        }
    }

    func updateGestionnaire(id: Int, data: PartialGestionnaire) async {
        do {
            try await service.updateGestionnaire(id: id, data)
            await fetchGestionnaires()
        } catch {
            errorMessage = "Erreur mise à jour : \(error.localizedDescription)"
        }
    }

    func deleteGestionnaire(id: Int) async {
        do {
            try await service.deleteGestionnaire(id: id)
            await fetchGestionnaires()
        } catch {
            errorMessage = "Erreur suppression : \(error.localizedDescription)"
        }
    }
}

struct GestionnaireCreate: Codable {
    let username: String
    let email: String
    let password: String
    let createdAt: String
    let updatedAt: String
}
struct PartialGestionnaire: Codable {
    let username: String?
    let email: String?
    let password: String?
    let updatedAt: String?
}
