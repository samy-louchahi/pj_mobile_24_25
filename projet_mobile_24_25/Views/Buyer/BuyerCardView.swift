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
        VStack(spacing: 12) {
            // 🧑‍💼 Nom
            Text(buyer.name)
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 6) {
                InfoRow(label: "Email", value: buyer.email)
                InfoRow(label: "Téléphone", value: buyer.phone ?? "Non renseigné")
                InfoRow(label: "Adresse", value: (buyer.address?.isEmpty == false ? buyer.address! : "Non renseignée"))
            }

            HStack(spacing: 16) {
                Button(action: onUpdate) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                        Text("Modifier")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .buttonStyle(BorderlessButtonStyle())

                Button(action: onDelete) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Supprimer")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .buttonStyle(BorderlessButtonStyle())
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

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
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
