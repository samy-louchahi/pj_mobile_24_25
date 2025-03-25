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
        VStack(spacing: 12) {
            // 🖼️ Image plus grande et avec coins arrondis
            AsyncImage(url: URL(string: game.picture)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipped()
            .cornerRadius(12)

            VStack(spacing: 4) {
                Text(game.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text("Éditeur: \(game.publisher)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Actions épurées
            HStack(spacing: 16) {
                Button(action: onViewDetails) {
                    Label("", systemImage: "eye")
                        .labelStyle(.titleAndIcon)
                        .font(.subheadline)
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.indigo)

                Button(action: onUpdate) {
                    Label("", systemImage: "pencil")
                        .labelStyle(.titleAndIcon)
                        .font(.subheadline)
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.blue)

                Button(action: onDelete) {
                    Label("", systemImage: "trash")
                        .labelStyle(.titleAndIcon)
                        .font(.subheadline)
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.red)
            }
            .padding(.top, 6)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
