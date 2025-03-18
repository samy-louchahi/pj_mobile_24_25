//
//  DepositCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct DepositCardView: View {
    let deposit: Deposit
    let onDelete: (Int) -> Void
    // Vous pouvez ajouter onUpdate et onViewDetails si nécessaire

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Dépôt #\(deposit.depositId)")
                    .font(.headline)
                Spacer()
                Text(deposit.depositDate, style: .date)
                    .font(.subheadline)
            }
            if let discount = deposit.discountFees {
                Text("Réduction: \(discount, specifier: "%.2f")%")
                    .font(.subheadline)
            }
            if let tag = deposit.tag {
                Text("Étiquette: \(tag)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            HStack {
                Button(action: {
                    generatePdf()
                }) {
                    Label("Télécharger", systemImage: "doc")
                }
                Spacer()
                Button(action: {
                    onDelete(deposit.depositId)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
    
    func generatePdf() {
        // Implémentez ici la logique de génération de PDF
    }
}
