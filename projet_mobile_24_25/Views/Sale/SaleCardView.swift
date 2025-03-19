//
//  SaleCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//


import SwiftUI

struct SaleCardView: View {
    let sale: Sale
    let seller: Seller?
    let onDelete: (Int) -> Void
    let onUpdate: (Sale) -> Void
    let onFinalize: (() -> Void)?

    var totalSale: Double {
        sale.saleDetails?.reduce(0) { acc, detail in
            let exemplaires = detail.depositGame?.exemplaires ?? [:]
            let soldExemplaires = exemplaires.values.prefix(detail.quantity)
            let subTotal = soldExemplaires.reduce(0) { subSum, ex in subSum + (ex.price ?? 0) }
            return acc + subTotal
        } ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Vente #\(sale.saleId ?? 0)")
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

                if let details = sale.saleDetails, !details.isEmpty {
                    List {
                        ForEach(details, id: \.depositGame?.depositGameId) { detail in
                            if let game = detail.depositGame?.game {
                                HStack {
                                    Text(game.name)
                                    Spacer()
                                    Text("x\(detail.quantity)")
                                        .bold()
                                    Text(formatCurrency(detailSubtotal(detail)))
                                        .bold()
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 150)
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
        print("Téléchargement de la facture pour la vente #\(sale.saleId)")
        // Implémentation du téléchargement ici
    }
}
