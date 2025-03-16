//
//  SellerViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI
import Combine

class SellerViewModel: ObservableObject {
    @Published var sellers: [Seller] = []
    @Published var loading: Bool = false
    @Published var errorMessage: String?

    // Form fields
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""

    @Published var editingSeller: Seller?
    @Published var showForm: Bool = false
    @Published var showDetail: Bool = false

    @Published var selectedSeller: Seller?

    private var cancellables = Set<AnyCancellable>()
    private let sellerService = SellerService.shared

    func fetchSellers() {
        loading = true
        sellerService.getSellers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errorMessage = "Erreur: \(error)"
                }
            } receiveValue: { sellers in
                self.sellers = sellers
            }
            .store(in: &cancellables)
    }

    func openAddForm() {
        editingSeller = nil
        name = ""
        email = ""
        phone = ""
        showForm = true
    }

    func openEditForm(_ seller: Seller) {
        editingSeller = seller
        name = seller.name ?? ""
        email = seller.email ?? ""
        phone = seller.phone ?? ""
        showForm = true
    }

    func closeForm() {
        showForm = false
    }

    func saveSeller() {
        // Validation
        guard !name.isEmpty, !email.isEmpty, !phone.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs obligatoires."
            return
        }
        errorMessage = nil

        let body = SellerCreate(name: name, email: email, phone: phone)
        if let existing = editingSeller {
            sellerService.updateSeller(existing.id, body)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.closeForm()
                        self.fetchSellers()
                    case .failure(let error):
                        self.errorMessage = "Erreur update : \(error)"
                    }
                } receiveValue: { _ in }
                .store(in: &cancellables)
        } else {
            sellerService.createSeller(body)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.closeForm()
                        self.fetchSellers()
                    case .failure(let error):
                        self.errorMessage = "Erreur création : \(error)"
                    }
                } receiveValue: { _ in }
                .store(in: &cancellables)
        }
    }

    func deleteSeller(_ seller: Seller) {
        sellerService.deleteSeller(seller.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.sellers.removeAll { $0.id == seller.id }
                case .failure(let error):
                    self.errorMessage = "Erreur suppression : \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    // Détails
    func openDetails(_ seller: Seller) {
        self.selectedSeller = seller
        self.showDetail = true
        // Ici, si tu veux charger du stock ou du saleDetail,  
        // tu peux déclencher d’autres requêtes.  
    }

    func closeDetails() {
        self.showDetail = false
        self.selectedSeller = nil
    }
}


