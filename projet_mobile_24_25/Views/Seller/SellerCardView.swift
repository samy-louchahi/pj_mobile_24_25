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
        VStack(alignment: .leading) {
            Text(seller.name ?? "No Name")
                .font(.headline)
            Text("Email: \(seller.email ?? "")")
            Text("Téléphone: \(seller.phone ?? "")")
            
            HStack {
                Button(action: {
                    // Empêche la propagation "tap" si tu veux
                    onUpdate()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                Spacer()
                Button(action: {
                    onDelete()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .onTapGesture {
            // Si tu veux naviguer vers le détail
            onSellerTapped()
        }
    }
}