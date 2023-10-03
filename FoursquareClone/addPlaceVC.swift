//
//  addPlaceVC.swift
//  FoursquareClone
//
//  Created by Berk Gülşen on 2.10.2023.
//

import UIKit

class addPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeAtmosphereText: UITextField!
    @IBOutlet weak var placeImageView: UIImageView!
    
    var isImageDefault = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
       
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        guard let placeName = placeNameText.text,
              let placeType = placeTypeText.text,
              let placeAtmosphere = placeAtmosphereText.text else {
            return
        }
        
        if placeName.isEmpty || placeType.isEmpty || placeAtmosphere.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Place name/type/atmosphere cannot be empty.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if isImageDefault {
            let alert = UIAlertController(title: "Error", message: "Please select an image for the place.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Eğer varsayılan fotoğraf ile aynı değilse işlemi devam ettir
        PlaceModel.sharedInstance.placeName = placeName
        PlaceModel.sharedInstance.placeType = placeType
        PlaceModel.sharedInstance.placeAtmosphere = placeAtmosphere
        PlaceModel.sharedInstance.placeImage = placeImageView.image!
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
    
    @objc func chooseImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            placeImageView.image = selectedImage
            
            // Seçilen fotoğraf varsayılan fotoğraf ile aynı mı kontrol et
            let defaultImage = UIImage(named: "taphere")
            isImageDefault = selectedImage.isEqual(defaultImage)
        }
        
        self.dismiss(animated: true)
    }
}
