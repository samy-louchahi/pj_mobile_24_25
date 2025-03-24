//
//  BuyerSectionView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

struct BuyerSectionView: View {
    @StateObject private var viewModel = BuyerViewModel()

    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView("Chargement des acheteurs...")
            } else if !viewModel.errorMessage.isNilOrEmpty {
                Text(viewModel.errorMessage ?? "")
                    .foregroundColor(.red)
            } else if viewModel.buyers.isEmpty {
                VStack(spacing: 10) {
                    Text("Aucun acheteur trouvé.")
                        .font(.title2)
                    Button("+ Ajouter un Acheteur") {
                        viewModel.openAddForm()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.buyers) { buyer in
                            BuyerCardView(
                                buyer: buyer,
                                onUpdate: { viewModel.openEditForm(buyer: buyer) },
                                onDelete: { Task { await viewModel.deleteBuyer(buyer) } }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
            }
        }
        .sheet(isPresented: $viewModel.showForm) {
            BuyerFormView(viewModel: viewModel)
        }
        .onAppear {
            Task { await viewModel.fetchBuyers() }
        }
    }
}
