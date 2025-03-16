//
//  SellerDetailView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//
import SwiftUI

struct SellerDetailView: View {
    @ObservedObject var viewModel: SellerViewModel
    let seller: Seller

    // Si tu veux stocker localement les "stocks" ou "balances",  
    // tu pourrais avoir un petit sub-ViewModel, etc.

    var body: some View {
        VStack {
            Text("Détails du Vendeur: \(seller.name ?? "")")
                .font(.title2)
                .padding()

            // Affichage Email, Téléphone
            Text("Email: \(seller.email ?? "")")
            Text("Téléphone: \(seller.phone ?? "")")

            // etc.  
            // Table de stocks / ventes / balances => en SwiftUI,  
            // c’est plus souvent une List ou un ScrollView + ForEach.  
        }
        .onAppear {
            // Charger éventuellement du stock  
            // via un appel à un "fetchSellerDetails" si tu veux
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Fermer") {
                    viewModel.closeDetails()
                }
            }
        }
    }
}
