//
//  BuyerListView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI

struct BuyerListView: View {
    @StateObject private var viewModel = BuyerViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView("Chargement des acheteurs...")
                } else if !viewModel.errorMessage.isNilOrEmpty {
                    Text(viewModel.errorMessage ?? "Erreur inconnue")
                        .foregroundColor(.red)
                } else if viewModel.buyers.isEmpty {
                    VStack(spacing: 10) {
                        Text("Aucun acheteur enregistré")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Ajoutez vos premiers acheteurs en les créant manuellement.")
                            .foregroundColor(.gray)
                        Button("+ Ajouter un Acheteur") {
                            viewModel.openAddForm()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                } else {
                    // Liste
                    List {
                        ForEach(viewModel.buyers) { buyer in
                            BuyerCardView(
                                buyer: buyer,
                                onUpdate: {
                                    viewModel.openEditForm(buyer: buyer)
                                },
                                onDelete: {
                                    viewModel.deleteBuyer(buyer)
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Liste des Acheteurs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+ Ajouter") {
                        viewModel.openAddForm()
                    }
                }
            }
            // sheet pour le form
            .sheet(isPresented: $viewModel.showForm) {
                BuyerFormView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchBuyers()
            }
        }
    }
}

/// Petit util pour checker si une string est vide ou nil
extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}
#Preview {
    BuyerListView()
}
