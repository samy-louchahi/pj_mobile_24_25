//  SellerCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI

struct SellerCardView: View {
    let seller: Seller
    let onUpdate: () -> Void
    let onDelete: () -> Void
    let onViewDetails: () -> Void 

    var body: some View {
        VStack(spacing: 12) {
            Text(seller.name ?? "Vendeur inconnu")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 6) {
                InfoRow(label: "Email", value: seller.email ?? "Non renseigné")
                InfoRow(label: "Téléphone", value: seller.phone?.isEmpty == false ? seller.phone! : "Non renseigné")
            }

            HStack(spacing: 16) {
                Button(action: onViewDetails) {
                    Label("Détails", systemImage: "person.crop.rectangle")
                        .labelStyle(.titleAndIcon)
                        .font(.subheadline)
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.indigo)

                Button(action: onUpdate) {
                    Label("Modifier", systemImage: "pencil")
                        .labelStyle(.titleAndIcon)
                        .font(.subheadline)
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.blue)

                Button(action: onDelete) {
                    Label("Supprimer", systemImage: "trash")
                        .labelStyle(.titleAndIcon)
                        .font(.subheadline)
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.red)
            }
            .padding(.top, 6)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        .padding(.horizontal)
        
    }
}

