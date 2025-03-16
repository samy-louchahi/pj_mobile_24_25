//
//  BuyerViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI
import Combine

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

    private var cancellables = Set<AnyCancellable>()
    private let buyerService = BuyerService.shared

    // Chargement de la liste
    func fetchBuyers() {
        loading = true
        buyerService.getBuyers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Erreur : \(error)"
                }
            } receiveValue: { buyers in
                self.buyers = buyers
            }
            .store(in: &cancellables)
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
    func saveBuyer() {
        // Validation
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !phone.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            errorMessage = "Veuillez remplir tous les champs obligatoires."
            return
        }
        errorMessage = nil

        let body = BuyerCreate(name: name, email: email, phone: phone, address: address)

        if let existing = editingBuyer {
            // Update
            buyerService.updateBuyer(existing.id, body)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.closeForm()
                        // On recharge la liste
                        self.fetchBuyers()
                    case .failure(let error):
                        self.errorMessage = "Erreur update : \(error)"
                    }
                } receiveValue: { updatedBuyer in
                    // Optionnel : Mettre à jour localement self.buyers
                }
                .store(in: &cancellables)
        } else {
            // Create
            buyerService.createBuyer(body)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.closeForm()
                        self.fetchBuyers()
                    case .failure(let error):
                        self.errorMessage = "Erreur création : \(error)"
                    }
                } receiveValue: { newBuyer in
                    // Optionnel
                }
                .store(in: &cancellables)
        }
    }

    // Suppression
    func deleteBuyer(_ buyer: Buyer) {
        buyerService.deleteBuyer(buyer.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    // Retirer localement
                    self.buyers.removeAll { $0.id == buyer.id }
                case .failure(let error):
                    self.errorMessage = "Erreur suppression : \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}