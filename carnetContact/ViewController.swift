//
//  ViewController.swift
//  carnetContact
//
//  Created by Jules Vial on 03/12/2019.
//  Copyright © 2019 Jules Vial. All rights reserved.
//

import UIKit
import CoreData


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

        

          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          let context = appDelegate.persistentContainer.viewContext
          let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        
        request.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for r in results as! [NSManagedObject] {
                    var nome = ""
                    var prenomTemp = ""
                    
                    if let name = r.value(forKey: "nom") as? String {
                        nome = name
                    }
                    if let pre = r.value(forKey: "prenom") as? String {
                        prenomTemp = pre
                    }
                    ContactService.shared.add(contact: Contact(nom: nome, prenom: prenomTemp))
                }
            }
        }catch{
            
        }
        
        
 
       
        

   
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
