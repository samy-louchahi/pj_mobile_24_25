//
//  SaleCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//

import SwiftUI

struct SaleCardView: View {
    let sale: Sale
    let localDetails: [LocalSaleDetail]?
    let seller: Seller?
    let onDelete: (Int) -> Void
    let onUpdate: (Sale) -> Void
    let onFinalize: (() -> Void)?

    @State private var showDetails = false

    var totalSale: Double {
        enrichedDetails?.reduce(0) { $0 + $1.subtotal } ?? 0
    }

    private var enrichedDetails: [LocalSaleDetail]? {
        if let localDetails {
            return localDetails
        }

        guard let saleDetails = sale.saleDetails else { return nil }

        return saleDetails.compactMap { detail in
            guard let dg = detail.depositGame else { return nil }
            let keys = detail.selectedKeys ?? []
            return LocalSaleDetail(depositGame: dg, selectedExemplaireKeys: keys)
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // 🔖 En-tête
            HStack {
                Text("Vente #\(sale.saleId)")
                    .font(.title3)
                    .bold()
                Spacer()
                HStack(spacing: 12) {
                    Button(action: { onUpdate(sale) }) {
                        Label("Modifier", systemImage: "pencil")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(BorderlessButtonStyle())

                    Button(action: { onDelete(sale.saleId) }) {
                        Label("Supprimer", systemImage: "trash")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }

            // ℹ️ Infos principales
            VStack(alignment: .leading, spacing: 6) {
                Text("🟢 Statut : \(sale.saleStatus.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.blue)

                Text("👤 Vendeur : \(seller?.name ?? "N/A")")
                    .font(.subheadline)

                Text("📅 Date : \(formattedDate(sale.saleDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            // ⬇️ Bouton toggle détails
            Button(action: {
                withAnimation {
                    showDetails.toggle()
                }
            }) {
                Label(showDetails ? "Masquer les jeux" : "Afficher les jeux vendus", systemImage: showDetails ? "chevron.up" : "chevron.down")
                    .font(.subheadline)
            }
            .buttonStyle(BorderlessButtonStyle())
            .foregroundColor(.gray)

            // 📦 Liste des jeux
            if showDetails, let details = enrichedDetails {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(details) { local in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(local.depositGame.game?.name ?? "Jeu inconnu")
                                .font(.headline)

                            ForEach(local.selectedExemplaireKeys, id: \.self) { key in
                                if let ex = local.depositGame.exemplaires?[key] {
                                    HStack {
                                        Text("• \(ex.state ?? "État inconnu")")
                                        Spacer()
                                        Text("\(formatCurrency(ex.price ?? 0))")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                            }

                            HStack {
                                Spacer()
                                Text("Sous-total : \(formatCurrency(local.subtotal))")
                                    .font(.subheadline)
                                    .bold()
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                }
            }

            // 💰 Total
            Text("💶 Total : \(formatCurrency(totalSale))")
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            // 🔴 Finaliser (si applicable)
            if sale.saleStatus.rawValue == "en cours", let onFinalize = onFinalize {
                Button(action: {
                    onFinalize()
                }) {
                    Label("Finaliser la vente", systemImage: "checkmark.seal.fill")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }

            // 📄 Générer PDF
            Button(action: {
                handleDownloadInvoice()
            }) {
                Label("Télécharger la facture", systemImage: "doc.richtext")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter.string(from: NSNumber(value: value)) ?? "\(value) €"
    }

    private func handleDownloadInvoice() {
        if let data = PDFUtils.generateInvoicePdf(for: sale, seller: seller, localDetails: localDetails) {
            PDFUtils.sharePdf(data, "Facture_\(sale.saleId).pdf")
        }
    }
}
struct LocalSaleDetail: Identifiable {
    let id = UUID()
    let depositGame: DepositGame
    let selectedExemplaireKeys: [String]
    
    var quantity: Int {
        selectedExemplaireKeys.count
    }
    
    var subtotal: Double {
        selectedExemplaireKeys.reduce(0) { sum, key in
            let price = depositGame.exemplaires?[key]?.price ?? 0
            return sum + price
        }
    }
}
