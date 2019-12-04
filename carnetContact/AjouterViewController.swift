//
//  AjouterViewController.swift
//  carnetContact
//
//  Created by Pedro Miguel Pérez Torres on 03/12/2019.
//  Copyright © 2019 Jules Vial. All rights reserved.
//

import UIKit

class AjouterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var InputFamil: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var image: UIImageView!
    var famillePicker: [String] = [String]()
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    
    
    
    @IBAction func closeAjouter(){
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        picker.delegate = self
        picker.dataSource = self
        famillePicker = ["Pere","Mere","Soeur","Frere","Coisin","Uncle"]
 
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
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return famillePicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return famillePicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        InputFamil.text = famillePicker[row]
    }
    
    
    
    
}
