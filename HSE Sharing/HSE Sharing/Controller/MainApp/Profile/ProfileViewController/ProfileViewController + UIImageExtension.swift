//
//  ProfileViewController + UIImageExtension.swift
//  HSE Sharing
//
//  Created by Екатерина on 03.04.2022.
//

import UIKit

// Все, что связано с установкой фото.
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = image
            currentUser?.photo = image.jpegData(compressionQuality: 1)?.base64EncodedString()
            makeRequest()
        } else {
            self.showAlertWith(message: "No image found.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func pickImage() {
        let imagePickerController = configureImagePickerController()
        let actionSheet = configureActionSheet()
        configureActions(actionSheet, imagePickerController)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func configureImagePickerController() -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }
    
    private func configureActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(
            title: EnterViewController.isEnglish ? "Image Source" : "Источник фотографии",
            message: EnterViewController.isEnglish ? "Select the source of your profile image" : "Выберите источник фотографии профиля", preferredStyle: .actionSheet)
        return actionSheet
    }
    
    private func configureActions(_ actionSheet: UIAlertController, _ imagePickerController: UIImagePickerController) {
        configureLibraryAction(actionSheet, imagePickerController)
        configureCameraAction(actionSheet, imagePickerController)
        configureCancelAction(actionSheet)
    }
    
    private func configureLibraryAction(_ actionSheet: UIAlertController, _ imagePickerController: UIImagePickerController) {
        actionSheet.addAction(UIAlertAction(
            title: EnterViewController.isEnglish ? "Photo Library" : "Галерея", style: .default, handler: { (action: UIAlertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true)
            } else {
                self.showAlertWith(
                    message: EnterViewController.isEnglish ? "Unable to access the photo library." : "Не удается получить доступ к библиотеке фотографий")
            }
        }))
    }
    
    private func configureCameraAction(_ actionSheet: UIAlertController, _ imagePickerController: UIImagePickerController) {
        actionSheet.addAction(UIAlertAction(
            title: EnterViewController.isEnglish ? "Camera" : "Камера", style: .default, handler: { (action: UIAlertAction) in
            actionSheet.dismiss(animated: true) {
                if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                    imagePickerController.sourceType = .camera
                    self.present(imagePickerController, animated: true)
                } else {
                    self.showAlertWith(
                        message: EnterViewController.isEnglish ? "Unable to access the camera" : "Не удается получить доступ к камере")
                }
            }
        }))
    }
    
    private func configureCancelAction(_ actionSheet: UIAlertController) {
        actionSheet.addAction(UIAlertAction(
            title: EnterViewController.isEnglish ? "Cancel" : "Отмена", style: .cancel, handler: nil))
    }
    
    private func showAlertWith(message: String){
        let alertController = UIAlertController(
            title: EnterViewController.isEnglish ? "Error when uploading a photo" : "Ошибка при загрузке фотографии", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: EnterViewController.isEnglish ? "OK" : "Ладушки", style: .default))
        present(alertController, animated: true)
    }
}
