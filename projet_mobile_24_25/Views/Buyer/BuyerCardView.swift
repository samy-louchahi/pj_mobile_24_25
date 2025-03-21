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
        VStack(alignment: .leading, spacing: 5) {
            Text(buyer.name)
                .font(.headline)
            Text("Email: \(buyer.email)")
                .font(.subheadline)
            Text("Téléphone: \(buyer.phone ?? "")")
                .font(.subheadline)
            Text("Adresse: \(buyer.address ?? "Non renseignée")")
                .font(.subheadline)

            HStack {
                Button(action: {
                    onUpdate()
                }) {
                    Image(systemName: "pencil")
                }
                .buttonStyle(BorderlessButtonStyle())

                Button(action: {
                    onDelete()
                }) {
                    Image(systemName: "trash")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
