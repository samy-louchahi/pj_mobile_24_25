# 📱 Projet Mobile 2024–2025 – Application SwiftUI

Application de gestion d’un dépôt-vente de jeux de société, réalisée dans le cadre du module de développement mobile (SwiftUI – MVVM).

---

## 👥 Équipe

- Samy Louchahi

---

## 🚀 Lancer le projet

### Prérequis
- Xcode 15 ou version supérieure
- iOS 17+
- Swift 5.9+
- Aucune dépendance externe à installer

### Installation
1. Cloner le dépôt :
   ```bash
   git clone https://github.com/votre-repo/projet_mobile_24_25.git
   cd projet_mobile_24_25
   ```

2. Ouvrir le projet avec Xcode :
   ```bash
   open projet_mobile_24_25.xcodeproj
   ```

3. Lancer l'app sur un simulateur ou un appareil iOS.

---

## 🔐 Comptes de connexion

L'application gère deux rôles : **Administrateur** et **Gestionnaire**.

### Compte Administrateur
- **Rôle** : Admin
- **Email** : `admin@example.com`
- **Mot de passe** : `admin123`

### Compte Gestionnaire
- **Rôle** : Gestionnaire
- **Nom d'utilisateur** : `Manager`
- **Mot de passe** : `12345`

---

## 📦 Modules et dépendances

Aucun module externe requis (pas de Firebase, ni Swift Package Manager pour ce projet).

Tout est codé en **SwiftUI** avec le design pattern **MVVM**.

---

## 📂 Structure du projet

Le projet suit une architecture MVVM claire avec les répertoires suivants :
- `Views/` : les interfaces utilisateur (SwiftUI)
- `ViewModels/` : la logique de présentation
- `Services/` : les appels réseau (API)
- `Models/` : les structures de données
- `Utils/` : extensions et helpers

---

## ✨ Fonctionnalités principales

- Authentification par rôle (Admin, Gestionnaire)
- Gestion des vendeurs, acheteurs, dépôts, ventes et jeux
- Génération de factures PDF
- Statistiques détaillées (ventes, bilans, jeux les plus vendus, etc.)
- Interface fluide et épurée
