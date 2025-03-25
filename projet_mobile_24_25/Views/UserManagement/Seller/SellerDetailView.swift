//
//  SellerDetailView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 16/03/2025.
//
import SwiftUI

struct SellerDetailView: View {
    @StateObject var viewModel: SellerDetailViewModel
    @State private var expandedDepositIds: Set<Int> = []
    @State private var expandedSaleIds: Set<Int> = []

    var body: some View {
        return Group{
        if viewModel.seller.name == nil && viewModel.deposits.isEmpty && viewModel.saleDetails.isEmpty {
            ProgressView("Chargement...")
                .task {
                    await viewModel.fetchAll()
                }
        } else {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Détail du vendeur")
                        .font(.largeTitle.bold())
                        .padding(.top)
                    
                    GroupBox {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.blue)
                                Text(viewModel.seller.name ?? "Nom inconnu")
                                    .font(.title2)
                                    .bold()
                            }

                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.blue)
                                Text(viewModel.seller.email ?? "Email non renseigné")
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Image(systemName: "phone")
                                    .foregroundColor(.blue)
                                Text(viewModel.seller.phone ?? "Téléphone non renseigné")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
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
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Dépôt #\(deposit.depositId) - \(formatted(deposit.depositDate))")
                                        .font(.subheadline.bold())
                                    if let tag = deposit.tag {
                                        Text("Étiquette : \(tag)")
                                    }

                                    Button(action: {
                                        withAnimation {
                                            if expandedDepositIds.contains(deposit.depositId) {
                                                expandedDepositIds.remove(deposit.depositId)
                                            } else {
                                                expandedDepositIds.insert(deposit.depositId)
                                            }
                                        }
                                    }) {
                                        Label(
                                            expandedDepositIds.contains(deposit.depositId) ? "Masquer les jeux" : "Afficher les jeux",
                                            systemImage: expandedDepositIds.contains(deposit.depositId) ? "chevron.up" : "chevron.down"
                                        )
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())

                                    if expandedDepositIds.contains(deposit.depositId) {
                                        if let depositGames = deposit.depositGames {
                                            ForEach(depositGames, id: \.id) { dg in
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("🎲 \(dg.game?.name ?? "Jeu inconnu")")
                                                        .font(.subheadline)
                                                    Text("Nombre d'exemplaires : \(dg.exemplaires?.count ?? 0)")
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                                Divider()
                                            }
                                        } else {
                                            Text("Aucun jeu pour ce dépôt.")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }

                                    Divider()
                                }
                            }
                        }
                    }
                    
                    GroupBox(label: Text("🎲 Jeux en stock").bold()) {
                        if viewModel.stocksParJeu.isEmpty {
                            Text("Aucun exemplaire en stock.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.stocksParJeu) { stock in
                                HStack {
                                    Text(stock.nomJeu)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("x\(stock.quantite)")
                                        .foregroundColor(.blue)
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
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Vente #\(detail.saleId)")
                                        .font(.subheadline.bold())
                                    Text("Quantité : \(detail.quantity)")

                                    Button(action: {
                                        withAnimation {
                                            if expandedSaleIds.contains(detail.id) {
                                                expandedSaleIds.remove(detail.id)
                                            } else {
                                                expandedSaleIds.insert(detail.id)
                                            }
                                        }
                                    }) {
                                        Label(
                                            expandedSaleIds.contains(detail.id) ? "Masquer les détails" : "Afficher les détails",
                                            systemImage: expandedSaleIds.contains(detail.id) ? "chevron.up" : "chevron.down"
                                        )
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())

                                    if expandedSaleIds.contains(detail.id) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            if let depositGame = detail.depositGame {
                                                Text("Jeu : \(depositGame.game?.name ?? "Inconnu")")
                                            }

                                            if let selected = detail.selectedKeys {
                                                ForEach(selected, id: \.self) { key in
                                                    if let exemplaire = detail.depositGame?.exemplaires?[key] {
                                                        Text("- \(key) • \(exemplaire.state ?? "État ?") • \(format(exemplaire.price ?? 0))")
                                                            .font(.caption)
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                            }

                                            if let buyer = detail.sale?.buyer {
                                                Text("🧍‍♂️ Acheteur : \(buyer.name)")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }

                                    Divider()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .task {
                await viewModel.fetchAll()
            }
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
