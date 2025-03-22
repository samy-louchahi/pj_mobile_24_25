//
//  SaleStep1View.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 19/03/2025.
//
import SwiftUI

struct ChosenSaleGame: Identifiable {
    var id: ObjectIdentifier
    let depositGameId: Int
    var selectedExemplaireKeys: [String]
    var quantity: Int {
        selectedExemplaireKeys.count
    }
}

struct SaleStep1View: View {
    @Binding var selectedSeller: Int?
    @Binding var selectedBuyer: Int?
    let sellers: [Seller]
    let buyers: [Buyer]
    let activeSession: Session?
    let onNext: () -> Void
    
    @State private var localError: String? = nil
    
    var body: some View {
        Form {
            Section(header: Text("Session Active")) {
                if let session = activeSession {
                    Text(session.name).foregroundColor(.secondary)
                } else {
                    Text("Aucune session active").foregroundColor(.red)
                }
            }
            Section(header: Text("Vendeur")) {
                Picker("Vendeur", selection: $selectedSeller) {
                    Text("-- Sélectionner --").tag(nil as Int?)
                    ForEach(sellers, id: \.id) { (seller: Seller) in
                        Text(seller.name!).tag(seller.sellerId as Int?)
                    }
                }
            }
            Section(header: Text("Acheteur (Optionnel)")) {
                Picker("Acheteur", selection: $selectedBuyer) {
                    Text("-- Aucun --").tag(nil as Int?)
                    ForEach(buyers, id: \.id) { (buyer: Buyer) in
                        Text(buyer.name).tag(buyer.buyerId as Int?)
                    }
                }
            }
            if let error = localError {
                Text(error).foregroundColor(.red)
            }
            Button("Étape Suivante") {
                if selectedSeller == nil {
                    localError = "Veuillez sélectionner un vendeur."
                } else {
                    localError = nil
                    onNext()
                }
            }
        }
        .navigationTitle("Étape 1")
    }
}
struct SaleStep2View: View {
    let depositGames: [DepositGame]
    @Binding var chosenGames: [ChosenSaleGame]
    let onNext: () -> Void
    let onBack: () -> Void

    @State private var localError: String?
    @State private var selectedGameForDetails: DepositGame? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Sélectionnez les jeux à vendre")) {
                    ForEach(depositGames, id: \.id) { dg in
                        Button {
                            selectedGameForDetails = dg
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(dg.game?.name ?? "Jeu inconnu").font(.headline)
                                    Text("Disponible : \(dg.exemplaires?.count ?? 0)").font(.subheadline)
                                }
                                Spacer()
                                Text("Quantité : \(chosenGames.first(where: { $0.depositGameId == dg.depositGameId })?.quantity ?? 0)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }

                if let error = localError {
                    Text(error).foregroundColor(.red)
                }

                HStack {
                    Button("Retour") { onBack() }
                    Spacer()
                    Button("Étape Suivante") {
                        if chosenGames.allSatisfy({ $0.quantity == 0 }) {
                            localError = "Veuillez sélectionner au moins un exemplaire."
                        } else {
                            localError = nil
                            onNext()
                        }
                    }
                }
            }
            .navigationDestination(item: $selectedGameForDetails) { depositGame in
                ExemplaireSelectionView(
                    depositGame: depositGame,
                    chosenGames: $chosenGames
                )
            }
            .navigationTitle("Étape 2")
        }
    }
}
struct SaleStep3View: View {
    let selectedSeller: Int?
    let selectedBuyer: Int?
    let saleDate: Date
    let saleStatus: String
    let localDetails: [LocalSaleDetail]
    let onConfirm: () -> Void
    let onBack: () -> Void

    var body: some View {
        Form {
            Section(header: Text("Récapitulatif")) {
                Text("Vendeur: \(selectedSeller.map(String.init) ?? "Non défini")")
                Text("Acheteur: \(selectedBuyer.map(String.init) ?? "Aucun")")
                Text("Date de vente: \(formattedDate(saleDate))")
                Text("Statut: \(saleStatus)")
            }

            Section(header: Text("Jeux sélectionnés")) {
                ForEach(localDetails) { detail in
                    SaleGameSummaryRow(localDetail: detail)
                }
            }

            Section {
                Text("Total : \(localDetails.reduce(0) { $0 + $1.subtotal }.formatted(.currency(code: "EUR")))")
                    .font(.title3)
                    .bold()
            }

            HStack {
                Button("Retour") { onBack() }
                Spacer()
                Button("Confirmer la vente") { onConfirm() }
            }
        }
        .navigationTitle("Étape 3")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct SaleGameSummaryRow: View {
    let localDetail: LocalSaleDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Jeu : \(localDetail.depositGame.game?.name ?? "Inconnu")")
                .font(.headline)

            ForEach(localDetail.selectedExemplaireKeys, id: \.self) { key in
                if let ex = localDetail.depositGame.exemplaires?[key] {
                    Text("- \(key) • \(ex.state ?? "État inconnu") • \(ex.price?.formatted() ?? "0€")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Text("Sous-total : \(localDetail.subtotal.formatted(.currency(code: "EUR")))")
                .font(.subheadline)
                .bold()
                .padding(.top, 4)
        }
    }
}
struct AddSaleWizardView: View {
    @ObservedObject var viewModel: SaleViewModel
    @State private var currentStep: Int = 1
    @State private var selectedSeller: Int? = nil
    @State private var selectedBuyer: Int? = nil
    @State private var saleDate: Date = Date()
    @State private var saleStatus: String = "en cours"
    @State private var chosenGames: [ChosenSaleGame] = []
    @State private var localDetails: [LocalSaleDetail] = []

    var body: some View {
        NavigationView {
            VStack {
                if currentStep == 1 {
                    SaleStep1View(
                        selectedSeller: $selectedSeller,
                        selectedBuyer: $selectedBuyer,
                        sellers: viewModel.sellers,
                        buyers: viewModel.buyers,
                        activeSession: viewModel.activeSession,
                        onNext: { currentStep = 2 }
                    )
                } else if currentStep == 2 {
                    let availableDepositGames = viewModel.depositGamesForSale(sellerId: selectedSeller, sessionId: viewModel.activeSession?.sessionId)
                    SaleStep2View(
                        depositGames: availableDepositGames,
                        chosenGames: $chosenGames,
                        onNext: {
                            buildLocalDetails()
                            currentStep = 3
                        },
                        onBack: { currentStep = 1 }
                    )
                } else if currentStep == 3 {
                    let availableDepositGames = viewModel.depositGamesForSale(
                        sellerId: selectedSeller,
                        sessionId: viewModel.activeSession?.sessionId
                    )
                    SaleStep3View(
                        selectedSeller: selectedSeller,
                        selectedBuyer: selectedBuyer,
                        saleDate: saleDate,
                        saleStatus: saleStatus,
                        localDetails: localDetails,
                        onConfirm: { finalizeSale() },
                        onBack: { currentStep = 2 }
                    )
                }
            }
            .navigationTitle("Création de Vente")
        }
    }

    private func finalizeSale() {
        Task {
            do {
                guard let sessionId = viewModel.activeSession?.sessionId else {
                    print("Erreur : aucune session active trouvée")
                    return
                }

                // Étape 1 : Créer la vente
                let saleToFinalize = SaleCreate(
                    buyer_id: selectedBuyer,
                    session_id: sessionId,
                    sale_date: formattedDate(saleDate),
                    sale_status: saleStatus
                )

                let createdSale =  await viewModel.createSale(saleToFinalize)
                print("saleId \(createdSale?.saleId ?? 00)")

                // Étape 2 : Créer les SaleDetails
                for detail in localDetails {
                    let saleDetail = SaleDetailCreate(
                        sale_id: createdSale!.saleId,
                        deposit_game_id: detail.depositGame.depositGameId,
                        quantity: detail.quantity // ← quantité réelle sélectionnée
                    )
                    await viewModel.createSaleDetail(saleDetail)
                }

                // Étape 3 : Créer l'opération de vente (commission, statut)
                let commission = 0.1 // Exemple de commission (10%)
                let saleOperation = SaleOperationCreate(
                    sale_id: createdSale!.saleId,
                    commission: commission,
                    sale_status: saleStatus,
                    sale_date: formattedDate(saleDate)
                )
                 await viewModel.createSalesOperation(saleOperation)

                print("Vente et détails créés avec succès !")
            }
        }
    }
    private func buildLocalDetails() {
        let availableDepositGames = viewModel.depositGamesForSale(
            sellerId: selectedSeller,
            sessionId: viewModel.activeSession?.sessionId
        )

        localDetails = chosenGames.compactMap { chosen in
            guard let dg = availableDepositGames.first(where: { $0.depositGameId == chosen.depositGameId }) else {
                return nil
            }
            let sortedKeys = chosen.selectedExemplaireKeys.sorted()
            return LocalSaleDetail(depositGame: dg, selectedExemplaireKeys: sortedKeys)
        }
    }
    private func formattedDate(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }
}
