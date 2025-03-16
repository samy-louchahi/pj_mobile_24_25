import Foundation

/// Représente un administrateur (table: admins).
struct Admin: Codable, Identifiable {
    /// Comme il n'y a pas de champ "id" explicite dans la table,
    /// on peut décider d'utiliser l'email comme identifiant unique.
    var id: String { email }

    let email: String
    /// Hashed password renvoyé par le back (ou vide si tu préfères ne pas l’exposer)
    let password: String
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        // On mappe ces champs selon les noms exacts dans la table
        case email
        case password
        case createdAt
        case updatedAt
    }
}
