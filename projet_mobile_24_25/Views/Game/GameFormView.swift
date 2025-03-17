//
//  GameFormView.swift
//  projet_mobile_24_25
//
//  Created by Samy Louchahi on 17/03/2025.
//


import SwiftUI

struct GameFormView: View {
    @ObservedObject var viewModel: GameViewModel

    // Champs
    @State private var name: String = ""
    @State private var publisher: String = ""
    @State private var description: String = ""

    @State private var imageData: Data? = nil
    @State private var showImagePicker = false

    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations")) {
                    TextField("Nom", text: $name)
                    TextField("Éditeur", text: $publisher)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3)
                }

                Section(header: Text("Image")) {
                    if let data = imageData, let uiImg = UIImage(data: data) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                    }
                    else if let editing = viewModel.editingGame {
                        // On affiche l’URL existante
                        AsyncImage(url: URL(string: editing.picture)) { image in
                            image.resizable()
                        } placeholder: {
                            Rectangle().foregroundColor(.gray)
                        }
                        .scaledToFit()
                        .frame(height: 120)
                    }

                    Button("Choisir une image") {
                        showImagePicker = true
                    }
                }

                // Erreur
                if let err = viewModel.errorMessage {
                    Text(err)
                        .foregroundColor(.red)
                }

                Section {
                    Button(viewModel.editingGame == nil ? "Ajouter" : "Mettre à jour") {
                        // On appelle la méthode du VM
                        if name.isEmpty || publisher.isEmpty {
                            self.errorMessage = "Veuillez remplir le nom et l'éditeur."
                        } else {
                            self.errorMessage = nil
                            let existingPic = viewModel.editingGame?.picture
                            viewModel.saveGame(
                                name: name,
                                publisher: publisher,
                                description: description,
                                existingPicture: existingPic,
                                imageData: imageData
                            )
                        }
                    }
                }
            }
            .navigationTitle(viewModel.editingGame == nil ? "Nouveau Jeu" : "Modifier Jeu")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        viewModel.closeForm()
                    }
                }
            }
        }
        .onAppear {
            // Préremplir si on édite un jeu existant
            if let editing = viewModel.editingGame {
                name = editing.name
                publisher = editing.publisher
                description = editing.description
                imageData = nil
            } else {
                name = ""
                publisher = ""
                description = ""
                imageData = nil
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImageData: $imageData)
        }
    }
}

// Un wrapper pour UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImageData: Data?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage,
               let data = uiImage.jpegData(compressionQuality: 0.8) {
                parent.selectedImageData = data
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
