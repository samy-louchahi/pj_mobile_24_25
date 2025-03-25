//
//  GameListView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct GameListView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showFileImporter = false

    let gridLayout = [GridItem(.adaptive(minimum: 170), spacing: 24)]

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack {
                    if viewModel.loading {
                        ProgressView("Chargement des jeux...")
                            .padding()
                    } else if let err = viewModel.errorMessage {
                        Text(err)
                            .foregroundColor(.red)
                            .padding()
                    } else if viewModel.filteredGames.isEmpty {
                        VStack(spacing: 12) {
                            Text("Aucun jeu disponible")
                                .font(.title2)
                                .bold()
                            Text("Ajoutez vos jeux ou importez un CSV.")
                                .foregroundColor(.gray)
                            HStack(spacing: 10) {
                                Button("+ Créer un nouveau jeu") {
                                    viewModel.openAddForm()
                                }
                                .buttonStyle(.borderedProminent)

                                Button("+ Importer CSV") {
                                    showFileImporter = true
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding()
                    } else {
                        VStack(spacing: 8) {
                            HStack(spacing: 12) {
                                TextField("Recherche par Nom", text: $viewModel.searchName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Toggle("Avec stock", isOn: $viewModel.filterHasStock)
                            }
                            .padding(.horizontal)
                            .onChange(of: viewModel.searchName) { _ in
                                viewModel.applyFilter()
                            }
                            .onChange(of: viewModel.filterHasStock) { _ in
                                viewModel.applyFilter()
                            }
                        }

                        ScrollView {
                            LazyVGrid(columns: gridLayout, spacing: 24) {
                                ForEach(viewModel.filteredGames) { game in
                                    GameCardView(
                                        game: game,
                                        onUpdate: { viewModel.openEditForm(game) },
                                        onDelete: { Task { await viewModel.deleteGame(game) } },
                                        onViewDetails: { viewModel.openDetail(game) }
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                    }
                }
            }
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
                Task { await viewModel.fetchGames() }
            }
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
                        Task { await viewModel.importCSV(data, fileName: csvURL.lastPathComponent) }
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
