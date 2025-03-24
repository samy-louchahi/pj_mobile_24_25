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
            VStack(spacing: 16) {
                if viewModel.loading {
                    ProgressView("Chargement des vendeurs...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.2)
                        .padding(.top, 40)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.sellers.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.2.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.6))
                        Text("Aucun vendeur trouvé")
                            .font(.title2)
                            .bold()
                        Text("Ajoutez un vendeur pour commencer à gérer ses dépôts et ventes.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                        Button(action: { viewModel.openAddForm() }) {
                            Label("Ajouter un Vendeur", systemImage: "plus.circle")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 10)
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.sellers) { seller in
                                SellerCardView(
                                    seller: seller,
                                    onUpdate: { viewModel.openEditForm(seller) },
                                    onDelete: { Task { await viewModel.deleteSeller(seller) } },
                                    onViewDetails: {
                                        self.selectedSeller = seller
                                        self.showDetail = true
                                    }
                                )
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Vendeurs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.openAddForm()
                    }) {
                        Label("Ajouter", systemImage: "plus")
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
       // .background(Color(.secondarySystemBackground))
    }
}
