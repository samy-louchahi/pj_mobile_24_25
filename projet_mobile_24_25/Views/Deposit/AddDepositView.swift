import SwiftUI


struct DepositGameEntry: Identifiable {
    let id: Int
    var game_id: Int?
    var exemplaires: [String: Exemplaire]
}

struct AddDepositView: View {
    @ObservedObject var viewModel: DepositViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss

    // Champs du formulaire
    @State private var selectedSeller: Int = 0
    @State private var depositDate: Date = Date()
    @State private var discountFees: Double = 0.0
    @State private var depositItems: [DepositGameEntry] = []
    @State private var nextItemId: Int = 1
    @State private var errorMessage: String?

    // Calcul de la session active (celle dont le status est true)
    private var activeSession: Session? {
        viewModel.sessions.first(where: { $0.status })
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Section Informations du Dépôt
                if let session = activeSession {
                    Text("Dépôt pour la session : \(session.name)")
                    Section{
                        Picker("Vendeur", selection: $selectedSeller) {
                            Text("Sélectionner un vendeur").tag(0)
                            ForEach(viewModel.sellers, id: \.id) { (seller : Seller) in
                                Text(seller.name!).tag(seller.sellerId)
                            }
                        }
                    }
                    Section{
                        DatePicker("Date de Dépôt", selection: $depositDate, displayedComponents: .date)
                    }
                    Section{
                        TextField("Réduction sur les frais (%)", value: $discountFees, format: .number)
                                                   .keyboardType(.decimalPad)
                    }
                } else {
                    Section {
                        Text("Aucune session active. Veuillez activer une session pour créer un dépôt.")
                            .foregroundColor(.red)
                    }
                }
                
                // Section Jeux à déposer
                Section(header: Text("Jeux à déposer")) {
                    ForEach($depositItems, id: \.id) { $item in
                        VStack(alignment: .leading) {
                            HStack {
                                Button(action: {
                                    removeDepositItem(id: item.id)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            DepositGameEntryCardView(
                                entry: $item,
                                games: viewModel.games,
                                onUpdateEntry: updateDepositItem,
                                onAddExemplaire: addExemplaireToItem,
                                onRemoveEntry: removeDepositItem
                            )
                        }
                        .padding(.vertical, 4)
                    }
                    Button("Ajouter un jeu") {
                        addDepositItem()
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                // Section d'affichage de l'erreur (si présente)
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Nouveau Dépôt")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { handleClose() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Valider") { handleSubmit() }
                }
            }
        }
        .onAppear {
            Task{
                await viewModel.fetchData()
            }
        }
    }
}

// MARK: - Fonctions de gestion
extension AddDepositView {
    private func addDepositItem() {
        let newItem = DepositGameEntry(
            id: nextItemId,
            game_id: nil,
            exemplaires: ["0": Exemplaire(price: 0, state: "neuf")]
        )
        depositItems.append(newItem)
        nextItemId += 1
    }
    
    private func updateDepositItem(id: Int, newGameId: Int) {
        if let index = depositItems.firstIndex(where: { $0.id == id }) {
            depositItems[index].game_id = newGameId
        }
    }
    
    private func addExemplaireToItem(id: Int) {
        if let index = depositItems.firstIndex(where: { $0.id == id }) {
            let newKey = String(depositItems[index].exemplaires.count)
            depositItems[index].exemplaires[newKey] = Exemplaire(price: 0, state: "neuf")
        }
    }
    
    private func removeDepositItem(id: Int) {
        depositItems.removeAll { $0.id == id }
    }
    
    private func handleSubmit() {
        // Vérifier qu'une session active existe et qu'un vendeur est sélectionné
        guard let session = activeSession, selectedSeller != 0 else {
            errorMessage = "Veuillez vérifier qu'une session active existe et sélectionner un vendeur."
            return
        }
        if depositItems.isEmpty {
            errorMessage = "Veuillez ajouter au moins un jeu à déposer."
            return
        }
        for item in depositItems {
            if item.game_id == nil {
                errorMessage = "Veuillez sélectionner un jeu pour chaque article."
                return
            }
        }
        
        // Transformation des articles en données attendues par le backend
        let gamesData = depositItems.map { item in
            DepositGameCreate(
                game_id: item.game_id!,
                quantity: item.exemplaires.count,
                exemplaires: item.exemplaires
            )
        }
        
        // Formatage de la date en "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let depositDateStr = formatter.string(from: depositDate)
        
        let depositData = DepositCreate(
            seller_id: selectedSeller,
            session_id: session.sessionId,
            deposit_date: depositDateStr,
            discount_fees: discountFees,
            games: gamesData
        )
        
        Task {await viewModel.createDeposit(depositData)}
        dismiss()
    }
    
    private func handleClose() {
        presentationMode.wrappedValue.dismiss()
    }
}
