//
//  SessionDetailView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI
import Combine

struct SessionDetailView: View {
    @ObservedObject var viewModel: SessionViewModel
    let sessionId: Int

    @State private var loading: Bool = false
    @State private var errorMessage: String?
    @State private var balance: GlobalBalance?

    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView("Chargement du bilan...")
                }
                else if let err = errorMessage {
                    Text(err).foregroundColor(.red)
                }
                else if let bal = balance {
                    // Afficher le bilan
                    Text("Frais de dépôt totaux: \(bal.totalDepositFees)")
                    Text("Total des ventes: \(bal.totalSales)")
                    Text("Total des commissions: \(bal.totalCommission)")
                    Text("Bénéfice total: \(bal.totalBenef)")
                }
                else {
                    Text("Aucun bilan disponible.")
                }
            }
            .navigationTitle("Détails Session")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        viewModel.closeDetail()
                    }
                }
            }
        }
    }

    
}
