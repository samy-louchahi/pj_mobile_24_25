//
//  GameViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    // Liste complète
    @Published var games: [Game] = []
    // Liste filtrée (selon publisher, hasStock)
    @Published var filteredGames: [Game] = []

    // Loading, error
    @Published var loading: Bool = false
    @Published var errorMessage: String?

    // Filtrage
    @Published var searchPublisher: String = ""
    @Published var filterHasStock: Bool = false
    // Stocks par jeu
    @Published var gameStocks: [Int: [Stock]] = [:]

    // Form
    @Published var showForm: Bool = false
    @Published var editingGame: Game? = nil

    // Détail
    @Published var showDetail: Bool = false
    @Published var detailGame: Game? = nil
    
    // Détail des stocks
    @Published var detailStocks: [Stock] = []
    @Published var detailLoading: Bool = false
    @Published var detailError: String?

    // CSV import
    // Pas d’état particulier si on ne veut pas faire un “loading import”

    private var cancellables = Set<AnyCancellable>()
    private let gameService = GameService.shared

    // MARK: - Init
    init() {
        // Observe searchPublisher/filterHasStock pour re-filtrer localement
        Publishers.CombineLatest($searchPublisher, $filterHasStock)
            .sink { [weak self] _, _ in
                self?.applyFilter()
            }
            .store(in: &cancellables)
    }

    // MARK: - Fetch
    func fetchGames() {
        loading = true
        gameService.getGames()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.loading = false
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errorMessage = "Erreur: \(error)"
                }
            } receiveValue: { games in
                self.games = games
                self.filteredGames = games // initial
                // On peut fetch stocks si on veut
                self.fetchStocksForAllGames(games)
            }
            .store(in: &cancellables)
    }

    // MARK: - Fetch stocks
    func fetchStocksForAllGames(_ games: [Game]) {
        // Charger les stocks pour chaque jeu
        // (on peut faire un “group” fetch comme en React)
        // ex: faire un .map + .zip, ou un each + combineLatest
        // Pour la démo, on va faire un each en série
        // en production, on peut faire en parallèle.
        // Pour simplifier, on loop en parallèle ici:

        let publishers = games.map { game in
            gameService.getGameStocks(game.id)
                .map { (game.id, $0) }
                .eraseToAnyPublisher()
        }

        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Erreur fetchStocks: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { results in
                // results est un array de (gameId, [Stock])
                var stocksMap: [Int: [Stock]] = [:]
                for (gid, stocks) in results {
                    stocksMap[gid] = stocks
                }
                self.gameStocks = stocksMap
                // Re-filtrer
                self.applyFilter()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Stocks for gameDetails
    func fetchStocksForDetail(game: Game) {
        detailLoading = true
        detailError = nil
        gameService.getGameStocks(game.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.detailLoading = false
                switch completion {
                case .finished: break
                case .failure(let err):
                    self.detailError = "Erreur: \(err)"
                }
            } receiveValue: { stocks in
                self.detailStocks = stocks
            }
            .store(in: &self.cancellables)
    }

    // MARK: - Filtrage
    func applyFilter() {
        var list = games

        // searchPublisher
        if !searchPublisher.isEmpty {
            list = list.filter {
                $0.publisher.lowercased().contains(searchPublisher.lowercased())
            }
        }

        if filterHasStock {
            list = list.filter { game in
                // On regarde si current_quantity > 0
                guard let stocks = gameStocks[game.id] else { return false }
                return stocks.contains(where: { $0.currentQuantity > 0 })
            }
        }

        filteredGames = list
    }

    // MARK: - Delete
    func deleteGame(_ game: Game) {
        gameService.deleteGame(game.id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.games.removeAll(where: { $0.id == game.id })
                    self.applyFilter()
                case .failure(let error):
                    self.errorMessage = "Erreur suppression : \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    // MARK: - Form
    func openAddForm() {
        editingGame = nil
        showForm = true
    }

    func openEditForm(_ game: Game) {
        editingGame = game
        showForm = true
    }

    func closeForm() {
        showForm = false
    }

    // MARK: - Detail
    func openDetail(_ game: Game) {
        detailGame = game
        showDetail = true
    }

    func closeDetail() {
        showDetail = false
        detailGame = nil
    }

    // MARK: - CSV
    func importCSV(_ csvData: Data, fileName: String) {
        var multipart = MultipartFormData()
        multipart.files["file"] = (filename: fileName, data: csvData, mimeType: "text/csv")

        gameService.importGames(multipart)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    // Re-fetch
                    self.fetchGames()
                case .failure(let error):
                    self.errorMessage = "Erreur import CSV : \(error)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
extension GameViewModel {
    /// Gère la création ou la mise à jour selon `editingGame`.
    func saveGame(
        name: String,
        publisher: String,
        description: String,
        existingPicture: String?,
        imageData: Data?
    ) {
        // 1. Construire le MultipartFormData
        var form = MultipartFormData()
        form.fields["name"] = name
        form.fields["publisher"] = publisher
        form.fields["description"] = description

        // Si on a une image
        if let data = imageData {
            form.files["picture"] = (
                filename: "upload.jpg",
                data: data,
                mimeType: "image/jpeg"
            )
        }
        // Sinon on garde l’URL existante
        else if let existingPic = existingPicture, !existingPic.isEmpty {
            form.fields["picture"] = existingPic
        }

        // 2. Choix CREATE ou UPDATE
        if let existing = editingGame {
            // UPDATE
            gameService.updateGame(existing.id, formData: form)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        // Fermer la form
                        self.showForm = false
                        // Raffraîchir la liste
                        self.fetchGames()
                    case .failure(let error):
                        self.errorMessage = "Erreur update : \(error)"
                    }
                } receiveValue: { updatedGame in
                    // Si besoin, on peut faire un traitement local
                }
                .store(in: &cancellables)
        } else {
            // CREATE
            gameService.createGame(formData: form)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.showForm = false
                        self.fetchGames()
                    case .failure(let error):
                        self.errorMessage = "Erreur création : \(error)"
                    }
                } receiveValue: { newGame in
                    //
                }
                .store(in: &cancellables)
        }
    }
}
