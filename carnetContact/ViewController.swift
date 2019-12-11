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
    var nom: String = ""
    var prenom: String = ""
    var mail: String = ""
    var dateCrea: Date = Date()
    var numero: Int = 0
    var groupe: String = ""
    var relFamille: String = ""
}

// ViewController classique
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let test = Contact(nom: "Vial", prenom: "Jules")
        let test1 = Contact(nom: "Perez", prenom: "Pedro")
        let test2 = Contact(nom: "Bruel", prenom: "Patrick")
        let test3 = Contact(nom: "Saby", prenom: "Julie")
        let test4 = Contact(nom: "Cesar", prenom: "Jules")
        let test5 = Contact(nom: "Bonnaire", prenom: "Jules")
        let test6 = Contact(nom: "Pinot", prenom: "Thibaut")
        let test7 = Contact(nom: "Alaphilippe michel jean", prenom: "Julian claude robert enguerrand jackie")
        let test8 = Contact(nom: "Froome", prenom: "Christopher")
        let test9 = Contact(nom: "Bardet", prenom: "Romain")
        let test10 = Contact(nom: "Poulidor", prenom: "Raymond")
        let test11 = Contact(nom: "Mercxk", prenom: "Eddy")
        let test12 = Contact(nom: "Bernal", prenom: "Egan")
        let test13 = Contact(nom: "Kristof", prenom: "Alexander")
        ContactService.shared.add(contact: test)
        ContactService.shared.add(contact: test1)
        ContactService.shared.add(contact: test2)
        ContactService.shared.add(contact: test3)
        ContactService.shared.add(contact: test4)
        ContactService.shared.add(contact: test5)
        ContactService.shared.add(contact: test6)
        ContactService.shared.add(contact: test7)
        ContactService.shared.add(contact: test8)
        ContactService.shared.add(contact: test9)
        ContactService.shared.add(contact: test10)
        ContactService.shared.add(contact: test11)
        ContactService.shared.add(contact: test12)
        ContactService.shared.add(contact: test13)
        ContactService.shared.sort(type: "nom")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // gestion du type de tri en fonction du segmented control
    @IBAction func triChanged(_ sender: Any) {
        switch segmented.selectedSegmentIndex {
        case 0:
            ContactService.shared.sort(type: "nom")
        case 1:
            ContactService.shared.sort(type: "prenom")
        case 2:
            ContactService.shared.sort(type: "date")
        default:
            break
        }
        tableView.reloadData()
    }
}

// ici le service qui permettra d'acceder aux données des contacts
class ContactService {
    static let shared = ContactService()
    private init() {
    }

    private(set) var contacts: [Contact] = []

    func add(contact: Contact) {
        contacts.append(contact)
    }
    // ATTENTION, IL FAUDRA PENSER A AJOUTER ICI EN UTILISANT ADD APRES AVOIR CLIQUE SUR PLUS EN HAUT A DROITE DE L'ECRAN

    func sort(type: String) {
        switch type {
        case "prenom":
            contacts.sort {
                $0.prenom < $1.prenom
            }
        case "nom":
            contacts.sort {
                $0.nom < $1.nom
            }
        case "date":
            contacts.sort {
                $0.dateCrea > $1.dateCrea
            }
        default:
            break
        }
    }
    func remove(at index: Int) {
        contacts.remove(at: index)
    }
    // pour retourner une methode count publique
    func count()-> Int {
        return contacts.count
    }
}

// pour gerer le remplissage de la liste
extension ViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        print("ca affiche le contact")
        print(ContactService.shared.contacts[indexPath.row])
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.user = ContactService.shared.contacts[indexPath.row]
        self.present(detailsViewController, animated: true, completion:nil)
    }
    
}
extension ViewController: UITabBarDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ContactService.shared.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
