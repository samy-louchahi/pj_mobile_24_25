//
//  GameDetailView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//

import SwiftUI

struct GameDetailView: View {
    @ObservedObject var viewModel: GameViewModel
    let game: Game

    var body: some View {
        NavigationView {
            // Au lieu de tout coder ici, on appelle une sous-fonction "content"
            content
                .navigationTitle("Détails: \(game.name)")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Fermer") {
                            viewModel.closeDetail()
                        }
                    }
                }
        }
        .onAppear {
            // Appel de la méthode du VM pour fetch
            Task {await viewModel.fetchStocksForDetail(game: game)}
        }
    }

    /// Vue séparée pour le contenu (ce qui était dans le ScrollView)
    @ViewBuilder
    private var content: some View {
        if viewModel.detailLoading {
            ProgressView("Chargement...")
        } else if let err = viewModel.detailError {
            Text(err)
                .foregroundColor(.red)
                .padding()
        } else {
            detailScrollView
        }
    }

    /// Un autre sous-bloc pour le ScrollView
    private var detailScrollView: some View {
        ScrollView {
            AsyncImage(url: URL(string: game.picture)) { image in
                image.resizable()
            } placeholder: {
                Rectangle().foregroundColor(.gray)
            }
            .frame(height: 200)

            Text(game.name)
                .font(.title)
                .padding(.top, 8)
            Text("Éditeur: \(game.publisher)")
                .foregroundColor(.secondary)

            Text("Description : \(game.description)")

            let totalInitial = viewModel.detailStocks.reduce(0) { $0 + $1.initialQuantity }
            let totalCurrent = viewModel.detailStocks.reduce(0) { $0 + $1.currentQuantity }

            VStack(alignment: .leading, spacing: 4) {
                Text("Quantité Initiale Totale: \(totalInitial)")
                Text("Quantité Actuelle Totale: \(totalCurrent)")
            }
            .padding(.top, 8)

        }
        .padding()
    }
}
