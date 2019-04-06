//
//  ViewController.swift
//  Have pet


import UIKit
import RealmSwift

class OwnerTableViewController: UITableViewController {

    var testPetsName: [String] = []
    var owners: Results<Owner>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        owners = Owner.all()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }


    func setupNavBar () {
        self.navigationItem.title = "Have Pet?"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.setLeftBarButton(editButtonItem, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tappedAddButton))
        self.navigationItem.setRightBarButton(addButton, animated: true)
    
    }
    

    
    @objc func tappedAddButton () {
        let alert = UIAlertController(title: "Owner Name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .alphabet
        }
        let add = UIAlertAction(title: "add", style: .default) { action in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            Owner.addOwner(text)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.isEditing = editing
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return owners?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        guard let owner = owners?[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = owner.name
        cell.detailTextLabel?.text = "\(owner.pets.count)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petsTVC = PetsTableViewController(indexPath: indexPath)
        self.navigationController?.pushViewController(petsTVC, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let owner = owners?[indexPath.row], editingStyle == .delete else {
            return
        }
        deleteOwner(owner)
    }
    
    func deleteOwner(_ owner: Owner) {
        owner.delete()
        self.tableView.reloadData()
    }
}

