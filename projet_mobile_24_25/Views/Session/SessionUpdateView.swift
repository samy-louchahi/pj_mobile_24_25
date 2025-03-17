//
//  SessionUpdateView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct SessionUpdateView: View {
    @ObservedObject var viewModel: SessionViewModel
    let session: Session
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2025, month: 1, day: 1)
        let endComponents = DateComponents(year: 2025, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        let startDate = calendar.date(from: startComponents)!
        let endDate = calendar.date(from: endComponents)!
        return startDate ... endDate
    }()

    // Champs
    @State private var name: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var fees: Double
    @State private var commission: Double
    @State private var status: Bool

    @State private var errorMessage: String?

    init(viewModel: SessionViewModel, session: Session) {
        self.viewModel = viewModel
        self.session = session
        // Initialiser les @State
        _name = State(initialValue: session.name)
        _startDate = State(initialValue: session.startDate)
        _endDate = State(initialValue: session.endDate)
        _fees = State(initialValue: session.fees)
        _commission = State(initialValue: session.commission)
        _status = State(initialValue: session.status)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Modifier la Session")) {
                    TextField("Nom", text: $name)
                    DatePicker("Date de début", selection: $startDate, in: dateRange)
                    DatePicker("Date de fin", selection: $endDate, in: dateRange)
                    TextField("Frais (%)", value: $fees, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Commission (%)", value: $commission, format: .number)
                        .keyboardType(.decimalPad)
                    Toggle("Statut Actif", isOn: $status)
                }
                    if let err = errorMessage {
                        Text(err)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        if name.isEmpty{
                            errorMessage = "Veuillez renseigner le nom de la session."
                            return
                        }
                        if startDate > endDate {
                            errorMessage = "La date de début doit précéder la date de fin."
                            return
                        }
                        let updated = SessionUpdate(
                            name: name,
                            start_date: startDate,
                            end_date: endDate,
                            fees: fees,
                            commission: commission,
                            status: status
                        )
                        viewModel.updateSession(sessionId: session.id, updated)
                    }) {
                        Text("Mettre à jour")
                            .fontWeight(.semibold)
                    }
            }
            .navigationTitle("Modifier Session")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fermer") {
                        viewModel.closeUpdateForm()
                    }
                }
            }
        }
    }
}
private func formatDate(_ dateString: String) -> String {
    // On parse la date "YYYY-MM-DD" ou autre
    // Ex rapide :
    let formatterIn = DateFormatter()
    formatterIn.dateFormat = "yyyy-MM-dd"
    if let date = formatterIn.date(from: dateString) {
        let formatterOut = DateFormatter()
        formatterOut.dateStyle = .medium
        return formatterOut.string(from: date)
    }
    return dateString
}

