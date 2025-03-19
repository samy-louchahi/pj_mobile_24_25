//
//  SellerFormView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI

struct SellerFormView: View {
    @ObservedObject var viewModel: SellerViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations Vendeur")) {
                    TextField("Nom", text: $viewModel.name)
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                    TextField("Téléphone", text: $viewModel.phone)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                Button(action: {
                    Task {await viewModel.saveSeller()}
                    viewModel.closeForm()
                }) {
                    Text(viewModel.editingSeller == nil ? "Ajouter" : "Mettre à jour")
                }
            }
            .navigationTitle(viewModel.editingSeller == nil ? "Nouveau Vendeur" : "Modifier Vendeur")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        viewModel.closeForm()
                    }
                }
            }
        }
    }
}
