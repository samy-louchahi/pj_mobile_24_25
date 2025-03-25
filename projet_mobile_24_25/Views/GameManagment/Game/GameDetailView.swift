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
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                content
                    .navigationTitle("Détails")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Fermer") {
                                viewModel.closeDetail()
                            }
                        }
                    }
            }
        }
        .onAppear {
            Task { await viewModel.fetchStocksForDetail(game: game) }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.detailLoading {
            ProgressView("Chargement…")
                .padding()
        } else if let err = viewModel.detailError {
            Text(err)
                .foregroundColor(.red)
                .padding()
        } else {
            detailScrollView
        }
    }

    private var detailScrollView: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: game.picture)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle().foregroundColor(.gray)
                }
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 5)
                .padding(.horizontal)

                VStack(spacing: 8) {
                    Text(game.name)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text("Éditeur : \(game.publisher)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                if !game.description.isEmpty {
                    GroupBox(label: Text("📖 Description")) {
                        Text(game.description)
                            .padding(.vertical, 4)
                    }
                }

                GroupBox(label: Text("📦 Stock")) {
                    let totalInitial = viewModel.detailStocks.reduce(0) { $0 + $1.initialQuantity }
                    let totalCurrent = viewModel.detailStocks.reduce(0) { $0 + $1.currentQuantity }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Quantité Déposé Totale")
                            Spacer()
                            Text("\(totalInitial)")
                        }

                        HStack {
                            Text("Quantité Restante Totale")
                            Spacer()
                            Text("\(totalCurrent)")
                        }
                    }
                    .font(.body)
                    .padding(.vertical, 4)
                }

                Spacer()
            }
            .padding()
        }
    }
}
