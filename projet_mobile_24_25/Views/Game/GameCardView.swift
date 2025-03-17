//
//  GameCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct GameCardView: View {
    let game: Game
    let onUpdate: () -> Void
    let onDelete: () -> Void
    let onViewDetails: () -> Void

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: game.picture)) { image in
                image.resizable()
            } placeholder: {
                Rectangle().foregroundColor(.gray)
            }
            .aspectRatio(contentMode: .fill)
            .frame(height: 80)
            .clipped()

            Text(game.name)
                .font(.headline)
                .padding(.top, 4)
            Text("Éditeur: \(game.publisher)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 4)

            HStack {
                Button(action: onUpdate) {
                    Image(systemName: "pencil")
                }
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                Spacer()
                Button(action: onViewDetails) {
                    Label("Détails", systemImage: "eye")
                        .labelStyle(.iconOnly)
                }
            }
            .padding(.bottom, 4)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}