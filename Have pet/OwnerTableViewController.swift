//
//  ViewController.swift
//  Have pet


import UIKit
import RealmSwift

class OwnerTableViewController: UITableViewController {

    var testPetsName: [String] = []
    var owners: Results<Owner>?
    var searchOwners: Results<Owner>?
    var searchBar: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        owners = Owner.all()
        self.tableView.reloadData()
    }


    func setupNavBar () {
        self.navigationItem.title = "Have Pet?"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.setLeftBarButton(editButtonItem, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tappedAddButton))
        self.navigationItem.setRightBarButton(addButton, animated: true)

        
        self.searchBar = {
            let search = UISearchController(searchResultsController: nil)
            // search.searchResultsUpdater = self
            search.obscuresBackgroundDuringPresentation = false
            search.hidesNavigationBarDuringPresentation = false
            self.navigationItem.searchController = search
            self.navigationItem.searchController?.searchBar.isHidden = false
            search.searchResultsUpdater = self
            search.searchBar.delegate = self
            // self.navigationItem.searchController?.definesPresentationContext = true
            return search
        }()

        
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
        
        if self.searchBar.isActive {
            return searchOwners?.count ?? 0
        } else {
            return owners?.count ?? 0
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        if self.searchBar.isActive {
            guard let searchOwner = searchOwners?[indexPath.row] else { return cell }
            cell.textLabel?.text = searchOwner.name
            cell.detailTextLabel?.text = "\(searchOwner.pets.count)"
            return cell
        }
        guard let owner = owners?[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = owner.name
        cell.detailTextLabel?.text = "\(owner.pets.count)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sendOwner: Owner?
        if searchBar.isActive {
            sendOwner = searchOwners?[indexPath.row]
        } else {
            sendOwner = owners?[indexPath.row]
        }
        guard let send = sendOwner else { return }
        let petsTVC = PetsTableViewController(send)
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


extension OwnerTableViewController:  UISearchResultsUpdating, UISearchBarDelegate{

    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != nil else {
            searchOwners = nil
            return
        }
        let searchText = searchController.searchBar.text?.lowercased()
        let predicate = NSPredicate(format: "name CONTAINS %@", searchText!)
        let realm = try! Realm()
        searchOwners = realm.objects(Owner.self).filter(predicate)
        tableView.reloadData()
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        tableView.reloadData()
        return true
    }
    

    
}
