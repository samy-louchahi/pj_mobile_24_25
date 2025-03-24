//
//  SellerListView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI

struct SellerListView: View {
    @StateObject private var viewModel = SellerViewModel()
    @State private var showDetail: Bool = false
    @State private var selectedSeller: Seller? = nil

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
                        Text("Aucun vendeur trouvé c'est tarpin triste ")
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
                                onDelete: { Task {await viewModel.deleteSeller(seller)} },
                                onViewDetails: {
                                        self.selectedSeller = seller
                                        self.showDetail = true
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
            
            .sheet(isPresented: $showDetail) {
                if let seller = selectedSeller {
                    SellerDetailView(viewModel: SellerDetailViewModel(seller: seller))
                }
            }
            .onAppear {
                Task {await viewModel.fetchSellers()}
            }
        }
    }
}
#Preview {
    SellerListView()
}
