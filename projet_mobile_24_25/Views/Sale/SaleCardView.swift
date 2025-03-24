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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Vente #\(sale.saleId)")
                    .font(.title3)
                    .bold()
                Spacer()
                Button(action: { onUpdate(sale) }) {
                    Image(systemName: "pencil")
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Button(action: { onDelete(sale.saleId) }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }

            Text("Statut: \(sale.saleStatus.rawValue)")
                .font(.subheadline)
                .foregroundColor(.blue)

            Text("Vendeur: \(seller?.name ?? "N/A")")
                .font(.subheadline)

            Text("Date: \(formattedDate(sale.saleDate))")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()

            // ▶️ Bouton de détails
            Button(action: {
                withAnimation {
                    showDetails.toggle()
                }
            }) {
                Label(showDetails ? "Masquer les jeux" : "Afficher les jeux vendus", systemImage: showDetails ? "chevron.up" : "chevron.down")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .buttonStyle(BorderlessButtonStyle())

            // 🧾 Détails vendus
            if showDetails, let details = enrichedDetails {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(details) { local in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(local.depositGame.game?.name ?? "Jeu inconnu")
                                .font(.headline)

                            ForEach(local.selectedExemplaireKeys, id: \.self) { key in
                                if let ex = local.depositGame.exemplaires?[key] {
                                    HStack {
                                        Text("• État : \(ex.state ?? "N/A")")
                                        Spacer()
                                        Text("\(formatCurrency(ex.price ?? 0))")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                            }

                            HStack {
                                Spacer()
                                Text("Sous-total: \(formatCurrency(local.subtotal))")
                                    .font(.subheadline)
                                    .bold()
                            }
                        }
                        .padding(8)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                }
            }

            // 🧮 Total
            Text("Total: \(formatCurrency(totalSale))")
                .font(.title3)
                .bold()

            // 🔴 Finalisation
            if sale.saleStatus.rawValue == "en cours", let onFinalize = onFinalize {
                Button("Finaliser la vente") {
                    onFinalize()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            // 📄 PDF
            Button("Télécharger la facture") {
                handleDownloadInvoice()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
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
