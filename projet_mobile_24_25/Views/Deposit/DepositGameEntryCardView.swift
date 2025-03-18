//
//  DepositGameEntryCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct DepositGameEntryCardView: View {
    @Binding var entry: DepositGameEntry
    @State private var selectedGameId: Int = 0

    let games: [Game]
    let onUpdateEntry: (Int, Int) -> Void
    let onAddExemplaire: (Int) -> Void
    let onRemoveEntry: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Picker("Sélectionner un jeu", selection: $selectedGameId) {
                Text("Sélectionner un jeu").tag(0)
                ForEach(games, id: \.id) { game in
                    Text(game.name).tag(game.id)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selectedGameId) { newValue in
                onUpdateEntry(entry.id, newValue)
                entry.game_id = newValue
            }
            
            ForEach(Array(entry.exemplaires.keys.sorted()), id: \.self) { key in
                if let ex = entry.exemplaires[key] {
                    HStack {
                        Text("Prix: ")
                        TextField("Prix", value: Binding(
                            get: { ex.price ?? 0 },
                            set: { newPrice in
                                var updatedEx = ex
                                updatedEx.price = newPrice
                                entry.exemplaires[key] = updatedEx
                            }
                        ), format: .number)
                        .keyboardType(.decimalPad)
                        Text("État: ")
                        Picker("État", selection: Binding(
                            get: { ex.state ?? "neuf" },
                            set: { newState in
                                var updatedEx = ex
                                updatedEx.state = newState
                                entry.exemplaires[key] = updatedEx
                            }
                        )) {
                            ForEach(["neuf", "très bon", "bon", "occasion"], id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
            }
            
            Button("Ajouter exemplaire") {
                onAddExemplaire(entry.id)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
    }
}
