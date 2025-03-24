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

    @State private var showDetails = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Dépôt #\(deposit.depositId)")
                    .font(.title3)
                    .bold()
                Spacer()
                Text(formattedDate(deposit.depositDate))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if let seller = deposit.seller {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.indigo)
                    Text(seller.name ?? "Vendeur inconnu")
                        .font(.subheadline)
                }
            }

            if let discount = deposit.discountFees {
                Text("Réduction sur frais : \(discount, specifier: "%.2f")%")
                    .font(.subheadline)
            }

            if let tag = deposit.tag, !tag.isEmpty {
                Text("Étiquette : \(tag)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }

            HStack {
                Button(action: {
                    if let data = PDFUtils.generatePdf(for: deposit) {
                        PDFUtils.sharePdf(data, "Depot_\(deposit.depositId).pdf")
                    }
                }) {
                    Label("Générer PDF", systemImage: "doc.richtext")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())

                Spacer()

                Button(action: {
                    onDelete(deposit.depositId)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }

            Divider()

            Button(action: {
                withAnimation {
                    showDetails.toggle()
                }
            }) {
                Label(showDetails ? "Masquer les jeux" : "Afficher les jeux déposés", systemImage: showDetails ? "chevron.up" : "chevron.down")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .buttonStyle(BorderlessButtonStyle())

            // Liste des jeux déposés
            if showDetails, let games = deposit.depositGames {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(games) { dg in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dg.game?.name ?? "Jeu inconnu")
                                .font(.headline)
                                .foregroundColor(.primary)

                            if let exemplaires = dg.exemplaires {
                                ForEach(exemplaires.sorted(by: { $0.key < $1.key }), id: \.key) { (key, ex) in
                                    HStack {
                                        Text("• Prix : \(ex.price ?? 0, specifier: "%.2f") €")
                                        Spacer()
                                        Text("État : \(ex.state ?? "Inconnu")")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                            } else {
                                Text("Aucun exemplaire")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(8)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                }
                .padding(.top, 6)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}
