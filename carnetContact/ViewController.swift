//
//  ViewController.swift
//  carnetContact
//
//  Created by Jules Vial on 03/12/2019.
//  Copyright © 2019 Jules Vial. All rights reserved.
//

import UIKit

// on crée ici la structure que suivra un contact
struct Contact {
    var nom = ""
    var prenom = ""
}

// ViewController classique
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// ici le service qui permettra d'acceder aux données des contacts
class ContactService {
    static let shared = ContactService()
    private init() {
        let test = Contact(nom: "Vial", prenom: "Jules")
        add(contact: test)
    }

    private(set) var contacts: [Contact] = []

    func add(contact: Contact) {
        contacts.append(contact)
    }
}


// pour gerer le remplissage de la liste
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactService.shared.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        let contact = ContactService.shared.contacts[indexPath.row]
        
        cell.textLabel?.text = contact.nom
        cell.detailTextLabel?.text = contact.prenom
        
        return cell
    }
}


