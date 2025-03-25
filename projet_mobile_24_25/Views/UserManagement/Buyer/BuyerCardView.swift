//
//  BuyerCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//


import SwiftUI

struct BuyerCardView: View {
    let buyer: Buyer
    let onUpdate: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // 🧑‍💼 Nom
            Text(buyer.name)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            VStack(spacing: 8) {
                InfoRow(label: "Email", value: buyer.email)
                InfoRow(label: "Téléphone", value: buyer.phone ?? "Non renseigné")
                InfoRow(label: "Adresse", value: buyer.address?.isEmpty == false ? buyer.address! : "Non renseignée")
            }

            Divider()

            HStack(spacing: 16) {
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
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(label) :")
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}
