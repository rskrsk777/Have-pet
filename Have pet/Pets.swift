//
//  Pets.swift
//  Have pet


import Foundation
import RealmSwift

@objcMembers class Owner: Object {
    dynamic var id = UUID().uuidString
    dynamic var name = ""
    let pets = List<Pet>()
    
    override static func primaryKey () -> String? {
        return "id"
    }
    
    convenience init (name: String) {
        self.init()
        self.name = name
    }

}

@objcMembers class Pet: Object {
    dynamic var animalName = ""
    dynamic var term = ""
    
    let owner = LinkingObjects(fromType: Owner.self, property: "pets")

}


extension Owner {
    
    @discardableResult
    static func addOwner (_ name: String, in realm: Realm = try! Realm()) -> Owner {
        let owner = Owner(name: name)
        try! realm.write {
            realm.add(owner)
        }
        return owner
    }
    
    static func all(in realm: Realm = try! Realm()) -> Results<Owner> {
        return realm.objects(Owner.self)
    }
    
    func addPet (name: String, term: String, in realm: Realm = try! Realm()) {
        try! realm.write {
            self.pets.append(Pet(value: ["animalName" : name, "term" : term]))
        }
    }
    
    func delete () {
        guard let realm = realm else { return }
        realm.beginWrite()
        realm.delete(self)
        try! realm.commitWrite()
    }
}
