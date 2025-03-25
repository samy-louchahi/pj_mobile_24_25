//
//  DepositPageView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct DepositListView: View {
    @StateObject private var viewModel = DepositViewModel()
    @State private var showAddDeposit = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView("Chargement des dépôts...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else if viewModel.deposits.isEmpty {
                    VStack(spacing: 16) {
                        Text("Aucun dépôt trouvé")
                            .font(.title2)
                            .bold()
                        Text("Enregistrez vos premiers dépôts pour les gérer facilement.")
                            .foregroundColor(.gray)
                        Button(action: { showAddDeposit = true }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Ajouter un dépôt")
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.deposits) { deposit in
                            DepositCardView(
                                deposit: deposit,
                                onDelete: { id in Task {await viewModel.deleteDeposit(id: id)} }
                                // Vous pouvez ajouter onUpdate et onViewDetails si nécessaire
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddDeposit = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddDeposit) {
                AddDepositView(viewModel: viewModel)
            }
            .onAppear {
                Task {await viewModel.fetchDeposits()}
            }
        }.background(Color(UIColor.secondarySystemBackground))
    }
}
