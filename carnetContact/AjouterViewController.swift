//
//  AjouterViewController.swift
//  carnetContact
//
//  Created by Pedro Miguel Pérez Torres on 03/12/2019.
//  Copyright © 2019 Jules Vial. All rights reserved.
//

import UIKit

class AjouterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var image: UIImageView!
    
    
    @IBAction func closeAjouter(){
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func PrendrePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil{
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                present(imagePicker, animated : true,  completion: nil)
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedPicture: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image.image = selectedPicture
            
            UIImageWriteToSavedPhotosAlbum(selectedPicture, nil, nil, nil)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
