//
//  TopGamesTableView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 24/03/2025.
//


import SwiftUI

struct TopGamesTableView: View {
    let topGames: [TopGame]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top 5 des jeux les plus vendus")
                .font(.title3)
                .bold()

            ForEach(topGames.prefix(5), id: \.gameName) { game in
                VStack(alignment: .leading) {
                    HStack {
                        Text(game.gameName)
                            .font(.headline)
                        Spacer()
                        Text("\(game.totalQuantity) vendus")
                            .font(.subheadline)
                    }
                    Text("Éditeur : \(game.publisher)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Total : \(game.totalAmount.formatted(.currency(code: "EUR")))")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 4)
                Divider()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}