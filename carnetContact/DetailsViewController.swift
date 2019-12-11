//
//  DetailsViewController.swift
//  carnetContact
//
//  Created by Pedro Perez Torres on 03/12/2019.
//  Copyright © 2019 Jules Vial. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var nomUser: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    var user: Contact!
    
    @IBAction func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nomUser.text = "" + user.prenom + " " + user.nom
        
        // pour image profil
        imgUser.layer.borderWidth = 1
        imgUser.layer.masksToBounds = false
        imgUser.layer.borderColor = UIColor.black.cgColor
        imgUser.layer.cornerRadius = imgUser.frame.height/2
        imgUser.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
