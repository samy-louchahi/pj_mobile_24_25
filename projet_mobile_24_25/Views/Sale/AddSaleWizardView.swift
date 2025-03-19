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
    var quantity: Int
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

    var body: some View {
        Form {
            Section(header: Text("Sélectionnez les jeux à vendre")) {
                ForEach(depositGames, id: \.id) { dg in
                    SaleGameRow(depositGame: dg, chosenGames: $chosenGames)
                }
            }

            if let error = localError {
                Text(error).foregroundColor(.red)
            }

            HStack {
                Button("Retour") { onBack() }
                Spacer()
                Button("Étape Suivante") {
                    if !chosenGames.contains(where: { $0.quantity > 0 }) {
                        localError = "Veuillez sélectionner au moins un jeu."
                    } else {
                        localError = nil
                        onNext()
                    }
                }
            }
        }
        .navigationTitle("Étape 2")
    }
}

struct SaleGameRow: View {
    let depositGame: DepositGame
    @Binding var chosenGames: [ChosenSaleGame]

    var available: Int {
        depositGame.exemplaires?.count ?? 0
    }

    var currentQty: Int {
        chosenGames.first(where: { $0.depositGameId == depositGame.depositGameId })?.quantity ?? 0
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Jeux :\(depositGame.gameId)").font(.headline)
                Text("Disponible : \(available)").font(.subheadline)
            }
            Spacer()
            Stepper(
                value: Binding<Int>(
                    get: {
                        if let index = chosenGames.firstIndex(where: { $0.depositGameId == depositGame.depositGameId }) {
                            return chosenGames[index].quantity
                        }
                        return 0
                    },
                    set: { newValue in
                        if let index = chosenGames.firstIndex(where: { $0.depositGameId == depositGame.depositGameId }) {
                            chosenGames[index].quantity = newValue
                        } else if newValue > 0 {
                            let newGame = ChosenSaleGame(id:  ObjectIdentifier(UUID() as AnyObject), depositGameId: depositGame.depositGameId, quantity: newValue)
                            chosenGames.append(newGame)
                        }
                    }
                ),
                in: 0...available
            ) {
                Text("Quantité: \(chosenGames.first(where: { $0.depositGameId == depositGame.depositGameId })?.quantity ?? 0)")
            }
        }
    }
}
struct SaleStep3View: View {
    let selectedSeller: Int?
    let selectedBuyer: Int?
    let saleDate: Date
    let saleStatus: String
    let chosenGames: [ChosenSaleGame]
    let depositGames: [DepositGame]
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
                gameListView()
            }
            
            HStack {
                Button("Retour") { onBack() }
                Spacer()
                Button("Confirmer la vente") { onConfirm() }
            }
        }
        .navigationTitle("Étape 3")
    }

    private func gameListView() -> some View {
        let gameMappings = chosenGames.compactMap { cg in
            depositGames.first(where: { $0.depositGameId == cg.depositGameId }).map { dg in
                (cg, dg)
            }
        }

        return ForEach(gameMappings, id: \.0.id) { cg, dg in
            SaleGameSummaryRow(chosenGame: cg, depositGame: dg)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct SaleGameSummaryRow: View {
    let chosenGame: ChosenSaleGame
    let depositGame: DepositGame

    var body: some View {
        HStack {
            Text("Jeu : \(depositGame.gameId)").font(.headline)
            Spacer()
            Text("Quantité: \(chosenGame.quantity)").font(.subheadline)
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
                        onNext: { currentStep = 3 },
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
                        chosenGames: chosenGames,
                        depositGames: availableDepositGames,
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
                let saleToFinalize = SaleCreate(
                    buyer_id: selectedBuyer,
                    session_id: sessionId,
                    sale_date: formattedDate(saleDate),
                    sale_status: saleStatus
                )
                print("Finalisation de la vente \(saleToFinalize)")
                await viewModel.createSale(saleToFinalize)
            } catch {
                print("Erreur lors de la finalisation de la vente: \(error)")
            }
        }
    }
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
