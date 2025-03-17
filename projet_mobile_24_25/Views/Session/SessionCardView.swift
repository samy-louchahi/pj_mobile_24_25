//
//  SessionCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct SessionCardView: View {
    let session: Session

    /// Callbacks
    let onDelete: (Int) -> Void
    let onUpdate: (Session) -> Void
    let onViewDetails: (Session) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(session.name)
                    .font(.headline)
                Spacer()
                HStack {
                    Button {
                        onUpdate(session)
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                    Button {
                        onDelete(session.id)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            Text("Début : \(session.startDate)")
                .font(.subheadline)
            Text("Fin : \(session.endDate)")
                .font(.subheadline)
            Text("Frais de dépôt : \(session.fees, specifier: "%.2f") %")
                .font(.subheadline)
            Text("Commission : \(session.commission, specifier: "%.2f") %")
                .font(.subheadline)
            Text("Statut : \(session.status ? "Active" : "Inactive")")
                .font(.subheadline)
                .foregroundColor(session.status ? .green : .red)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .onTapGesture {
            onViewDetails(session)
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
}
