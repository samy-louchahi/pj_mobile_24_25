//
//  BuyerViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//

import SwiftUI

@MainActor
class BuyerViewModel: ObservableObject {
    // Liste des buyers
    @Published var buyers: [Buyer] = []
    @Published var loading: Bool = false
    @Published var errorMessage: String?

    // Champs du formulaire (Add/Update)
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var address: String = ""

    // Pour différencier "ajout" vs "édition"
    @Published var editingBuyer: Buyer?
    @Published var showForm: Bool = false

    private let buyerService = BuyerService.shared

    // Chargement de la liste
    func fetchBuyers() async {
        loading = true
        do {
            buyers = try await buyerService.getBuyers()
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
        }
        loading = false
    }

    // Ouvrir le formulaire pour ajouter
    func openAddForm() {
        editingBuyer = nil
        name = ""
        email = ""
        phone = ""
        address = ""
        showForm = true
    }

    // Ouvrir le formulaire pour modifier
    func openEditForm(buyer: Buyer) {
        editingBuyer = buyer
        name = buyer.name
        email = buyer.email
        phone = buyer.phone ?? ""
        address = buyer.address ?? ""
        showForm = true
    }

    // Fermer le formulaire
    func closeForm() {
        showForm = false
    }

    // Créer ou mettre à jour
    func saveBuyer() async {
        // Validation
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !phone.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Veuillez remplir tous les champs obligatoires."
            return
        }
        errorMessage = nil
        let body = BuyerCreate(name: name, email: email, phone: phone, address: address)
        do {
            if let existing = editingBuyer {
                _ = try await buyerService.updateBuyer(existing.id, body)
            } else {
                _ = try await buyerService.createBuyer(body)
            }
            closeForm()
            await fetchBuyers()
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
        }
    }

    // Suppression
    func deleteBuyer(_ buyer: Buyer) async {
        do {
            try await buyerService.deleteBuyer(buyer.id)
            buyers.removeAll { $0.id == buyer.id }
        } catch {
            errorMessage = "Erreur suppression : \(error.localizedDescription)"
        }
    }
}
