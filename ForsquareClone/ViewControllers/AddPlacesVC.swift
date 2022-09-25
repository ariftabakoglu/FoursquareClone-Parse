//
//  AddPlacesVC.swift
//  ForsquareClone
//
//  Created by Arif TABAKOĞLU on 23.09.2022.
//

import UIKit
import PhotosUI

class AddPlacesVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeAtmosphereTextfield: UITextField!
    @IBOutlet weak var placeTypeTextfield: UITextField!
    @IBOutlet weak var placeNameTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClicked))
        
        imageView.addGestureRecognizer(imageGesture)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
        
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if (placeNameTextfield.text != "") && (placeTypeTextfield.text != "") && (placeAtmosphereTextfield.text != "") {
            
            if let choosenImage = imageView.image {
                
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameTextfield.text!
                placeModel.placeType = placeTypeTextfield.text!
                placeModel.placeAtmosphere = placeAtmosphereTextfield.text!
                placeModel.placeImage = choosenImage
                
                performSegue(withIdentifier: "toMapVC", sender: nil)
            }
            
        }else{
            
            let alertController = UIAlertController(title: "Error", message: "Place Name/Type/Atmosphere??", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            
            alertController.addAction(okButton)
            
            self.present(alertController, animated: true)
        }
        
    }
    
    @objc func imageViewClicked(){
        
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
    
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      
        dismiss(animated: true,completion: nil)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let myimage = image as? UIImage{
                    DispatchQueue.main.async {
                        self.imageView.image = myimage
                    }
                }else{
                    print(error?.localizedDescription ?? "Error")
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Fail", preferredStyle: UIAlertController.Style.alert)
            
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { clicked in
                        self.imageViewClicked()
                    }
                    
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true)
                    
                }
            }
            
        }
    }
}
