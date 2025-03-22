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

    var totalSale: Double {
        if let localDetails {
            return localDetails.reduce(0) { $0 + $1.subtotal }
        }
        return sale.saleDetails?.reduce(0) { acc, detail in
            guard let exemplaires = detail.depositGame?.exemplaires else { return acc }
            let sortedExemplaires = exemplaires.sorted { $0.key < $1.key }.map { $0.value }
            let soldExemplaires = sortedExemplaires.prefix(detail.quantity)
            let subTotal = soldExemplaires.reduce(0) { sum, ex in sum + (ex.price ?? 0) }
            return acc + subTotal
        } ?? 0
    }
    
    private var enrichedDetails: [LocalSaleDetail]? {
        if let localDetails {
            return localDetails
        }

        guard let saleDetails = sale.saleDetails else { return nil }

        return saleDetails.compactMap { detail in
            guard let dg = detail.depositGame else { return nil }

            let keys = detail.selectedKeys ?? []
            print("keys \(keys)")
            return LocalSaleDetail(depositGame: dg, selectedExemplaireKeys: keys)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Vente #\(sale.saleId)")
                    .font(.headline)
                    .bold()
                Spacer()
                HStack {
                    Button(action: { onUpdate(sale) }) {
                        Image(systemName: "pencil")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button(action: {
                        if let saleId: Int? = sale.saleId {
                            onDelete(saleId ?? 0)
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            Text("Statut: \(sale.saleStatus)")
                .font(.subheadline)
                .foregroundColor(.blue)
            
            Text("Vendeur: \(seller?.name ?? "N/A")")
                .font(.subheadline)

            Text("Date de vente: \(sale.saleDate)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            VStack(alignment: .leading) {
                Text("Jeux vendus:")
                    .font(.headline)
                    .padding(.top, 5)

                if let details = enrichedDetails {
                    List {
                        ForEach(details) { local in
                            VStack(alignment: .leading) {
                                Text(local.depositGame.game?.name ?? "Jeu inconnu")
                                    .font(.headline)

                                ForEach(local.selectedExemplaireKeys, id: \.self) { key in
                                    if let ex = local.depositGame.exemplaires?[key] {
                                        HStack {
                                            Text("• État: ")
                                                .font(.caption)
                                            Spacer()
                                            Text("\(ex.state ?? "État ?")")
                                                .font(.caption)
                                            Spacer()
                                            Text(formatCurrency(ex.price ?? 0))
                                                .font(.caption)
                                        }
                                        .foregroundColor(.gray)
                                    }
                                }

                                HStack {
                                    Spacer()
                                    Text("Sous-total: \(formatCurrency(local.subtotal))")
                                        .font(.subheadline)
                                        .bold()
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .frame(maxHeight: 200)
                } else {
                    Text("Aucun jeu vendu")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Text("Total: \(formatCurrency(totalSale)) €")
                .font(.title3)
                .bold()

            if sale.saleStatus.rawValue == "en cours", let onFinalize = onFinalize {
                Button(action: onFinalize) {
                    Text("Finaliser la vente")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            Button(action: handleDownloadInvoice) {
                Text("Télécharger la facture")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }

    private func formattedDate(_ dateString: String?) -> String {
        guard let dateString = dateString, let date = ISO8601DateFormatter().date(from: dateString) else {
            return "Inconnu"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter.string(from: NSNumber(value: value)) ?? "\(value) €"
    }

    private func detailSubtotal(_ detail: SaleDetail) -> Double {
        let exemplaires = detail.depositGame?.exemplaires ?? [:]
        let soldExemplaires = exemplaires.values.prefix(detail.quantity)
        return soldExemplaires.reduce(0) { subSum, ex in subSum + (ex.price ?? 0) }
    }

    private func handleDownloadInvoice() {
        print("📄 Téléchargement de la facture pour la vente #\(sale.saleId)")
        
        if let data = PDFUtils.generateInvoicePdf(for: sale, seller: seller, localDetails: localDetails){
            PDFUtils.sharePdf(data, "Facture_\(sale.saleId)")
        } else {
            print("Erreur lors de la génération du PDF")
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
