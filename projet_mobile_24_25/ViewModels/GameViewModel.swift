//
//  GameViewModel.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//

import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    // Liste complète
    @Published var games: [Game] = []
    // Liste filtrée
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

    private let gameService = GameService.shared

    init() {
        Task { await fetchGames() }
    }

    // MARK: - Fetch Games
    func fetchGames() async {
        loading = true
        do {
            let gamesList = try await gameService.getGames()
            self.games = gamesList
            self.filteredGames = gamesList
            await fetchStocksForAllGames(gamesList) // Fetch des stocks après
        } catch {
            errorMessage = "Erreur lors de la récupération des jeux : \(error.localizedDescription)"
        }
        loading = false
    }

    // MARK: - Fetch Stocks
    func fetchStocksForAllGames(_ games: [Game]) async {
        var stocksMap: [Int: [Stock]] = [:]

        await withTaskGroup(of: (Int, [Stock]).self) { group in
            for game in games {
                group.addTask {
                    do {
                        let stocks = try await self.gameService.getGameStocks(game.id)
                        return (game.id, stocks)
                    } catch {
                        print("Erreur récupération stocks pour game \(game.id) : \(error)")
                        return (game.id, [])
                    }
                }
            }

            for await (gameId, stocks) in group {
                stocksMap[gameId] = stocks
            }
        }

        gameStocks = stocksMap
        applyFilter()
    }
    
    // MARK: - Fetch Stocks for Detail
    func fetchStocksForDetail(game: Game) async {
        detailLoading = true
        do {
            detailStocks = try await gameService.getGameStocks(game.id)
        } catch {
            detailError = "Erreur lors de la récupération des stocks : \(error.localizedDescription)"
        }
        detailLoading = false
    }

    // MARK: - Filtrage
    func applyFilter() {
        var list = games

        if !searchPublisher.isEmpty {
            list = list.filter { $0.publisher.lowercased().contains(searchPublisher.lowercased()) }
        }

        if filterHasStock {
            list = list.filter { game in
                guard let stocks = gameStocks[game.id] else { return false }
                return stocks.contains(where: { $0.currentQuantity > 0 })
            }
        }

        filteredGames = list
    }

    // MARK: - Delete
    func deleteGame(_ game: Game) async {
        do {
            try await gameService.deleteGame(game.id)
            games.removeAll(where: { $0.id == game.id })
            applyFilter()
        } catch {
            errorMessage = "Erreur suppression : \(error.localizedDescription)"
        }
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

    // MARK: - CSV Import
    func importCSV(_ csvData: Data, fileName: String) async {
        var multipart = MultipartFormData()
        multipart.files["file"] = (filename: fileName, data: csvData, mimeType: "text/csv")

        do {
            try await gameService.importGames(multipart)
            await fetchGames() // Re-fetch après import
        } catch {
            errorMessage = "Erreur import CSV : \(error.localizedDescription)"
        }
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
    ) async {
        var form = MultipartFormData()
        form.fields["name"] = name
        form.fields["publisher"] = publisher
        form.fields["description"] = description

        if let data = imageData {
            form.files["picture"] = (filename: "upload.jpg", data: data, mimeType: "image/jpeg")
        } else if let existingPic = existingPicture, !existingPic.isEmpty {
            form.fields["picture"] = existingPic
        }

        do {
            if let existing = editingGame {
                // UPDATE
                _ = try await gameService.updateGame(existing.id, formData: form)
            } else {
                // CREATE
                _ = try await gameService.createGame(formData: form)
            }
            showForm = false
            await fetchGames()
        } catch {
            errorMessage = "Erreur lors de l'opération : \(error.localizedDescription)"
        }
    }
}
