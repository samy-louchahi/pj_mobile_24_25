//
//  SessionCardView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct SessionCardView: View {
    let session: Session

    let onDelete: (Int) -> Void
    let onUpdate: (Session) -> Void
    let onViewDetails: (Session) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(session.name)
                    .font(.title3)
                    .bold()
                Spacer()
                HStack(spacing: 12) {
                    Button {
                        onUpdate(session)
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())

                    Button {
                        onDelete(session.id)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Début : \(formatDate(session.startDate))")
                Text("Fin : \(formatDate(session.endDate))")
                Text("Frais de dépôt : \(session.fees, specifier: "%.2f") %")
                Text("Commission : \(session.commission, specifier: "%.2f") %")
                Text("Statut : \(session.status ? "Active" : "Inactive")")
                    .foregroundColor(session.status ? .green : .red)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
        .onTapGesture {
            onViewDetails(session)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}
