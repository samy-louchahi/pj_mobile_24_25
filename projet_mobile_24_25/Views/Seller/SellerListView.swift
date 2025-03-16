//
//  SellerListView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI

struct SellerListView: View {
    @StateObject private var viewModel = SellerViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView("Chargement des vendeurs...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.sellers.isEmpty {
                    // Équivalent du "aucun vendeur trouvé"
                    VStack(spacing: 10) {
                        Text("Aucun vendeur trouvé")
                            .font(.title2)
                            .bold()
                        Text("Ajoutez un vendeur pour commencer à gérer ses dépôts et ventes.")
                            .foregroundColor(.gray)
                        Button("+ Ajouter un Vendeur") {
                            viewModel.openAddForm()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                } else {
                    // Liste des vendeurs
                    List {
                        ForEach(viewModel.sellers) { seller in
                            SellerCardView(
                                seller: seller,
                                onUpdate: { viewModel.openEditForm(seller) },
                                onDelete: { viewModel.deleteSeller(seller) },
                                onSellerTapped: {
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Liste des Vendeurs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+ Ajouter") {
                        viewModel.openAddForm()
                    }
                }
            }
            // Présente le formulaire comme une sheet
            .sheet(isPresented: $viewModel.showForm) {
                SellerFormView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchSellers()
            }
        }
    }
}
#Preview {
    SellerListView()
}
