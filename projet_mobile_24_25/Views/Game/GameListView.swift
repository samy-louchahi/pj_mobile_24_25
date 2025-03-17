//
//  GameListView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct GameListView: View {
    @StateObject private var viewModel = GameViewModel()

    // Pour CSV import
    @State private var showFileImporter = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView("Chargement des jeux...")
                } else if let err = viewModel.errorMessage {
                    Text(err).foregroundColor(.red)
                } else if viewModel.filteredGames.isEmpty {
                    // Équivalent “aucun jeu”
                    VStack(spacing: 12) {
                        Text("Aucun jeu disponible")
                            .font(.title2)
                        Text("Ajoutez vos jeux ou importez un CSV.")
                            .foregroundColor(.gray)
                        HStack(spacing: 10) {
                            Button("+ Créer un nouveau jeu") {
                                viewModel.openAddForm()
                            }
                            Button("+ Importer CSV") {
                                showFileImporter = true
                            }
                        }
                    }
                } else {
                    // Barre de recherche
                    HStack(spacing: 8) {
                        TextField("Recherche par éditeur", text: $viewModel.searchPublisher)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Toggle("Avec stock", isOn: $viewModel.filterHasStock)
                    }
                    .padding()

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)]) {
                            ForEach(viewModel.filteredGames) { game in
                                GameCardView(
                                    game: game,
                                    onUpdate: { viewModel.openEditForm(game) },
                                    onDelete: { viewModel.deleteGame(game) },
                                    onViewDetails: { viewModel.openDetail(game) }
                                )
                                .frame(height: 200)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Liste des Jeux")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { viewModel.openAddForm() }) {
                            Label("Ajouter un jeu", systemImage: "plus")
                        }
                        Button(action: {
                            showFileImporter = true
                        }) {
                            Label("Importer CSV", systemImage: "tray.and.arrow.down")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            // Sheet => GameForm
            .sheet(isPresented: $viewModel.showForm) {
                GameFormView(viewModel: viewModel)
            }
            // Sheet => GameDetail
            .sheet(isPresented: $viewModel.showDetail) {
                if let detail = viewModel.detailGame {
                    GameDetailView(viewModel: viewModel, game: detail)
                }
            }
            .onAppear {
                viewModel.fetchGames()
            }
            // FileImporter iOS 14+
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.commaSeparatedText, .plainText],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let csvURL = urls.first else { return }
                    do {
                        let data = try Data(contentsOf: csvURL)
                        viewModel.importCSV(data, fileName: csvURL.lastPathComponent)
                    } catch {
                        print("Erreur lecture du CSV: \(error)")
                    }
                case .failure(let e):
                    print("Erreur FileImporter: \(e)")
                }
            }
        }
    }
}

#Preview {
    GameListView()
}
