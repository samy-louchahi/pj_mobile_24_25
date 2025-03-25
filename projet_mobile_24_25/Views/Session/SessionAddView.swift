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
    init(viewModel: SessionViewModel) {
        self.viewModel = viewModel
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.fees = fees
        self.commission = commission
        self.errorMessage = errorMessage
    }
    // Champs
    @State private var name: String = ""
    @State private var startDate: Date = nil ?? Date()
    @State private var endDate: Date = nil ?? Date()
    @State private var fees: Double = 0
    @State private var commission: Double = 0

    @State private var errorMessage: String?
    var activeSession: Session? {
        viewModel.sessions.first(where: { $0.status })
    }
    
    func datesChevauchent(_ start1: Date, _ end1: Date, _ start2: Date, _ end2: Date) -> Bool {
        return max(start1, start2) <= min(end1, end2)
    }
    
    

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nouvelle Session")) {
                    TextField("Nom", text: $name)
                    DatePicker("Date de début", selection: $startDate)
                    DatePicker("Date de fin", selection: $endDate)
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
                    errorMessage = nil

                    guard !name.isEmpty else {
                        errorMessage = "Veuillez remplir tous les champs requis."
                        return
                    }

                    if let active = activeSession,
                       datesChevauchent(startDate, endDate, active.startDate, active.endDate) {
                        errorMessage = "La période chevauche une session active existante."
                        return
                    }

                    let newSession = SessionCreate(
                        name: name,
                        start_date: startDate,
                        end_date: endDate,
                        fees: fees,
                        commission: commission
                    )

                    Task {
                        await viewModel.createSession(newSession)
                        viewModel.closeAddForm()
                    }
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
