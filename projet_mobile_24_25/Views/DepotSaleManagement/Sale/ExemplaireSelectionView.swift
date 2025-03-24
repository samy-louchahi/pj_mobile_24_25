//
//  ExemplaireSelectionView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 22/03/2025.
//


import SwiftUI

struct ExemplaireSelectionView: View {
    let depositGame: DepositGame
    @Binding var chosenGames: [ChosenSaleGame]
    
    @Environment(\.presentationMode) var presentationMode
    
    var exemplaires: [(String, Exemplaire)] {
        depositGame.exemplaires?.sorted { $0.key < $1.key } ?? []
    }

    var selectedKeys: Binding<Set<String>> {
        Binding(
            get: {
                if let chosen = chosenGames.first(where: { $0.depositGameId == depositGame.depositGameId }) {
                    return Set(chosen.selectedExemplaireKeys)
                }
                return []
            },
            set: { newSet in
                if let index = chosenGames.firstIndex(where: { $0.depositGameId == depositGame.depositGameId }) {
                    chosenGames[index].selectedExemplaireKeys = Array(newSet)
                } else {
                    let new = ChosenSaleGame(
                        id: ObjectIdentifier(UUID() as AnyObject),
                        depositGameId: depositGame.depositGameId,
                        selectedExemplaireKeys: Array(newSet)
                    )
                    chosenGames.append(new)
                }
            }
        )
    }

    var body: some View {
        Form {
            Section(header: Text("Exemplaires disponibles")) {
                ForEach(exemplaires, id: \.0) { key, exemplaire in
                    Toggle(isOn: Binding<Bool>(
                        get: {
                            selectedKeys.wrappedValue.contains(key)
                        },
                        set: { isSelected in
                            if isSelected {
                                selectedKeys.wrappedValue.insert(key)
                            } else {
                                selectedKeys.wrappedValue.remove(key)
                            }
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text("État : \(exemplaire.state ?? "N/A")")
                            Text("Prix : \(String(format: "%.2f€", exemplaire.price ?? 0))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            Button("Valider") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle(depositGame.game?.name ?? "Exemplaires")
    }
}