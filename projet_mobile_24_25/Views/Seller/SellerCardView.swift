//
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
    let onSellerTapped: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // 👤 Nom du vendeur
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
                Button(action: onUpdate) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                        Text("Modifier")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Button(action: onDelete) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Supprimer")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top, 6)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        .padding(.horizontal)
        .onTapGesture {
            onSellerTapped()
        }
    }
}

