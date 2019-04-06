//
//  PetsTableViewController.swift
//  Have pet

import UIKit
import RealmSwift

class PetsTableViewController: UITableViewController {
    
    var owners: Results<Owner>?
    var owner: Owner?
    var pets: List<Pet>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pets = owner?.pets
        setupNavBar()
    }
    
    convenience init(_ owner: Owner) {
        self.init()
        self.owner = owner
    }
    
    func setupNavBar () {
        self.navigationItem.title = owner?.name
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tappedAddButton))
        self.navigationItem.setRightBarButton(addButton, animated: true)
        
    }
    
    @objc func tappedAddButton () {
        let alert = UIAlertController(title: "Add pet", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "name"
            textField.keyboardType = .alphabet
        })
        alert.addTextField { (textField) in
            textField.placeholder = "category"
            textField.keyboardType = .alphabet
        }
        
        alert.addAction(UIAlertAction(title: "add", style: .default, handler: { (action) in
            guard let name = alert.textFields?[0].text, let category = alert.textFields?[1].text else {
                return
            }
            self.owner?.addPet(name: name, category: category)
            self.tableView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = pets?[indexPath.row].animalName
        cell.detailTextLabel?.text = pets?[indexPath.row].category
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.isEditing = editing
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let _ = pets?[indexPath.row], editingStyle == .delete else {
            return
        }
        let realm = try! Realm()
        realm.beginWrite()
        // owner?.pets.remove(at: indexPath.row)
        realm.delete((owner?.pets[indexPath.row])!)
        try! realm.commitWrite()
        self.tableView.reloadData()
        
    }
}
