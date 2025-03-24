//
//  SellerSectionView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

struct SellerSectionView: View {
    @StateObject private var viewModel = SellerViewModel()
    @State private var showDetail = false
    @State private var selectedSeller: Seller?

    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView("Chargement des vendeurs…")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if viewModel.sellers.isEmpty {
                VStack(spacing: 10) {
                    Text("Aucun vendeur enregistré.")
                        .font(.title2)
                    Button("+ Ajouter un Vendeur") {
                        viewModel.openAddForm()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
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
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
            }
        }
        .sheet(isPresented: $viewModel.showForm) {
            SellerFormView(viewModel: viewModel)
        }
        .sheet(isPresented: $showDetail) {
            if let seller = selectedSeller {
                SellerDetailView(viewModel: SellerDetailViewModel(seller: seller))
            }
        }
        .onAppear {
            Task { await viewModel.fetchSellers() }
        }
    }
}
