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
    
    var sections = [String]()
    
    var filteredContact = [String: [Contact]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ContactService.shared.sort(type: "nom")
        loadDatas()
        
    }
    
    func loadDatas() {
        self.sections = []
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
        
        for contact in ContactService.shared.contacts {
            let firstLetter = String(describing: contact.nom.first)
            if filteredContact[firstLetter] != nil {
                filteredContact[firstLetter]!.append(contact)
            } else {
                filteredContact[firstLetter] = [contact]
            }
            if (!self.sections.contains(String(describing: contact.nom.first))) {
                self.sections.append(String(describing: contact.nom.first))
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func changement() {
        loadDatas()
    }
    
    // gestion du type de tri en fonction du segmented control
    @IBAction func triChanged(_ sender: Any) {
        switch segmented.selectedSegmentIndex {
        case 0:
            ContactService.shared.sort(type: "nom")
            self.sections = []
            self.filteredContact = [String: [Contact]]()
            for contact in ContactService.shared.contacts {
                let firstLetter = String(describing: contact.nom.first)
                if filteredContact[firstLetter] != nil {
                    filteredContact[firstLetter]!.append(contact)
                } else {
                    filteredContact[firstLetter] = [contact]
                }
                if (!self.sections.contains(String(describing: contact.nom.first))) {
                    self.sections.append(String(describing: contact.nom.first))
                }
            }
        case 1:
            ContactService.shared.sort(type: "prenom")
            self.sections = []
            self.filteredContact = [String: [Contact]]()
            for contact in ContactService.shared.contacts {
                let firstLetter = String(describing: contact.prenom.first)
                if filteredContact[firstLetter] != nil {
                    filteredContact[firstLetter]!.append(contact)
                } else {
                    filteredContact[firstLetter] = [contact]
                }
                if (!self.sections.contains(String(describing: contact.prenom.first))) {
                    self.sections.append(String(describing: contact.prenom.first))
                }
            }
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
        if (segmented.selectedSegmentIndex != 2) {
            return self.sections.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (segmented.selectedSegmentIndex != 2) {
            return self.sections[section]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmented.selectedSegmentIndex != 2) {
            let letter = self.sections[section]
            return filteredContact[letter]!.count
        } else {
            return ContactService.shared.contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (segmented.selectedSegmentIndex != 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
            let letter = self.sections[indexPath.section]
            cell.textLabel?.text = filteredContact[letter]![indexPath.row].nom
            cell.detailTextLabel?.text = filteredContact[letter]![indexPath.row].prenom
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
            cell.textLabel?.text = ContactService.shared.contacts[indexPath.row].nom
            cell.detailTextLabel?.text = ContactService.shared.contacts[indexPath.row].prenom
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        let letter = self.sections[indexPath.section]
        detailsViewController.user = filteredContact[letter]![indexPath.row]
        self.present(detailsViewController, animated: true, completion:nil)
    }
}
extension ViewController: UITabBarDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO : a corriger, pas de supression dans la base
            if (segmented.selectedSegmentIndex != 2) {
                // TODO : gerer supression
            } else {
                ContactService.shared.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
