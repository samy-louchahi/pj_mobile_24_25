//
//  SellerDetailView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//
import SwiftUI

struct SellerDetailView: View {
    @StateObject var viewModel: SellerDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Détail du vendeur")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("Nom : \(viewModel.seller.name ?? "N/A")")
                    .font(.title2)
                
                GroupBox(label: Text("Résumé financier").bold()) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("💰 Total des ventes : \(format(viewModel.totalSales))")
                        Text("💸 Frais de dépôt payés : \(format(viewModel.totalDepositFees))")
                        Text("📉 Commissions : \(format(viewModel.totalCommission))")
                        Text("✅ À reverser au vendeur : \(format(viewModel.montantARetourner))")
                            .bold()
                    }
                    .padding(.vertical)
                }
                
                GroupBox(label: Text("📦 Dépôts").bold()) {
                    if viewModel.deposits.isEmpty {
                        Text("Aucun dépôt effectué.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.deposits) { deposit in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Dépôt #\(deposit.depositId) - \(formatted(deposit.depositDate))")
                                    .font(.subheadline.bold())
                                if let tag = deposit.tag {
                                    Text("Étiquette : \(tag)")
                                }
                            }
                            Divider()
                        }
                    }
                }
                
                GroupBox(label: Text("🧾 Ventes réalisées").bold()) {
                    if viewModel.saleDetails.isEmpty {
                        Text("Aucune vente réalisée.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.saleDetails) { detail in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Vente #\(detail.saleId)")
                                Text("Quantité : \(detail.quantity)")
                                if let keys = detail.selectedKeys {
                                    Text("Exemplaires : \(keys.joined(separator: ", "))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Divider()
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            Task {
                await viewModel.fetchAll()
            }
        }
    }

    func format(_ value: Double) -> String {
        value.formatted(.currency(code: "EUR"))
    }

    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}
