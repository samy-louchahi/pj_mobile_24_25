//
//  SellerViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//

import SwiftUI

@MainActor
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

    private let sellerService = SellerService.shared

    init() {
        Task { await fetchSellers() }
    }

    // MARK: - Fetch Sellers
    func fetchSellers() async {
        do {
            loading = true
            sellers = try await sellerService.getSellers()
        } catch {
            errorMessage = "Erreur : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Form Management
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

    // MARK: - Save Seller (Create or Update)
    func saveSeller() async {
        guard !name.isEmpty, !email.isEmpty, !phone.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs obligatoires."
            return
        }
        errorMessage = nil

        let body = SellerCreate(name: name, email: email, phone: phone)

        do {
            if let existing = editingSeller {
                // Update Seller
                _ = try await sellerService.updateSeller(existing.id, body)
            } else {
                // Create Seller
                _ = try await sellerService.createSeller(body)
            }
            closeForm()
            await fetchSellers()
        } catch {
            errorMessage = "Erreur lors de l'opération : \(error.localizedDescription)"
        }
    }

    // MARK: - Delete Seller
    func deleteSeller(_ seller: Seller) async {
        do {
            loading = true
            try await sellerService.deleteSeller(seller.id)
            sellers.removeAll { $0.id == seller.id }
        } catch {
            errorMessage = "Erreur suppression : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Détails
    func openDetails(_ seller: Seller) {
        selectedSeller = seller
        showDetail = true
    }

    func closeDetails() {
        showDetail = false
        selectedSeller = nil
    }
}
