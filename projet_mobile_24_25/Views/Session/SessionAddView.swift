//
//  SessionAddView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

/// Vue pour ajouter une nouvelle session
struct SessionAddView: View {
    @ObservedObject var viewModel: SessionViewModel

    // Champs
    @State private var name: String = ""
    @State private var startDate: String = ""
    @State private var endDate: String = ""
    @State private var fees: Double = 0
    @State private var commission: Double = 0

    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nouvelle Session")) {
                    TextField("Nom", text: $name)
                    DatePickerField(label: "Date de Début", dateString: $startDate)
                    DatePickerField(label: "Date de Fin", dateString: $endDate)
                    TextField("Frais (%)", value: $fees, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Commission (%)", value: $commission, format: .number)
                        .keyboardType(.decimalPad)
                }

                if let err = errorMessage {
                    Text(err)
                        .foregroundColor(.red)
                }

                Button("Ajouter") {
                    if name.isEmpty || startDate.isEmpty || endDate.isEmpty {
                        errorMessage = "Veuillez remplir tous les champs requis."
                        return
                    }
                    // Créer la session
                    let newSession = SessionCreate(
                        name: name,
                        start_date: startDate,
                        end_date: endDate,
                        fees: fees,
                        commission: commission
                    )
                    viewModel.createSession(newSession)
                }
            }
            .navigationTitle("Créer une Session")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fermer") {
                        viewModel.closeAddForm()
                    }
                }
            }
        }
    }
}

/// Petit composant pour gérer un champ Date => String
struct DatePickerField: View {
    let label: String
    @Binding var dateString: String

    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
            DatePicker("", selection: Binding<Date>(
                get: { dateFromString(dateString) ?? Date() },
                set: { newVal in
                    dateString = stringFromDate(newVal)
                }
            ), displayedComponents: .date)
            .labelsHidden()
        }
    }

    private func dateFromString(_ str: String) -> Date? {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.date(from: str)
    }

    private func stringFromDate(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: date)
    }
}
