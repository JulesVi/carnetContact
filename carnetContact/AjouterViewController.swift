//
//  AjouterViewController.swift
//  carnetContact
//
//  Created by Pedro Miguel Pérez Torres on 03/12/2019.
//  Copyright © 2019 Jules Vial. All rights reserved.
//

import UIKit

class AjouterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
 
    
    
    @IBOutlet weak var InputFamil: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var image: UIImageView!
 
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    
    
    
    @IBAction func closeAjouter(){
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var Relationfamilial: UITextField!
    @IBOutlet weak var SelectRelation: UIPickerView!
    
    var family = ["Pere","Mere","Soeur"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return family.count
     }
    
    func pickerView(_pickerView:UIPickerView, titleForRow row:Int, forComponent component: Int)-> String? {
        self.view.endEditing(true)
        return family[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.InputFamil.text = self.family[row]
        self.picker.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.InputFamil{
            self.picker.isHidden=false
            textField.endEditing(true)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func selectPoto (_sender: Any){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated : true,  completion: nil)
        }
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
            if(imagePicker.sourceType == .camera){
                UIImageWriteToSavedPhotosAlbum(selectedPicture, nil, nil, nil)
            }
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
   
    
    
    
}
