//
//  SalePageView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//


import SwiftUI

struct SaleView: View {
    @ObservedObject var viewModel = SaleViewModel()

    var body: some View {
        VStack {
            Text("Gestion des Ventes")
                .font(.largeTitle)
                .bold()
                .padding()

            if viewModel.loading {
                ProgressView("Chargement des ventes...")
            } else if viewModel.sales.isEmpty {
                VStack {
                    Image(systemName: "bag.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(.blue)
                    Text("Aucune vente trouvée")
                        .font(.title2)
                        .bold()
                    Text("Ajoutez une nouvelle vente pour suivre les transactions.")
                        .foregroundColor(.gray)
                    Button("+ Enregistrer une vente") {
                        // Afficher la modal d’ajout
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                SaleListView(viewModel: viewModel)
            }
        }
    }
}
