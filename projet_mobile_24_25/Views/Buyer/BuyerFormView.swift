//
//  BuyerFormView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI

struct BuyerFormView: View {
    @ObservedObject var viewModel: BuyerViewModel  // On récupère le même ViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations Acheteur")) {
                    TextField("Nom", text: $viewModel.name)
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                    TextField("Téléphone", text: $viewModel.phone)
                    TextField("Adresse", text: $viewModel.address)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                Button(action: {
                    viewModel.saveBuyer()
                }) {
                    Text(viewModel.editingBuyer == nil ? "Ajouter" : "Mettre à jour")
                }
            }
            .navigationTitle(viewModel.editingBuyer == nil
                             ? "Nouveau Buyer"
                             : "Modifier Buyer")
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