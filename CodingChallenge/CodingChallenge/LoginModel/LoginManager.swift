//
//  LoginManager.swift
//  CodingChallenge
//
//  Created by Imran Kazi on 06/01/23.
//
import CoreData
import UIKit

class LoginManager {
    static let sharedManager = LoginManager()
    private init() {}
    private enum LoginManagerConstant {
        static let blankValue = ""
        static let entityName = "User"

    }
    
    func addDatabaseValues() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managerObjectContext = appDelegate?.persistentContainer.viewContext else { return }
        guard let entityDesc = NSEntityDescription.entity(forEntityName: LoginManagerConstant.entityName, in: managerObjectContext) else { return }
        
        let user1 =  User(entity: entityDesc, insertInto: managerObjectContext)
        user1.username = "nilofar_01"
        user1.password = "##NIL@90"
        
        let user2 =  User(entity: entityDesc, insertInto: managerObjectContext)
        user2.username = "nilofar_02"
        user2.password = "##Manaa@90"
        
        saveContext(context: managerObjectContext)
    }
    
    func getPasswordOfUsername(username: String) -> String {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managerObjectContext = appDelegate?.persistentContainer.viewContext else { return ""}
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: LoginManagerConstant.entityName)
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        do {
            let result = try managerObjectContext.fetch(fetchRequest)
            if result.count > 0, let user = result.last as? User, let passcode = user.password {
                return passcode
            } else {
                return LoginManagerConstant.blankValue
            }
            
        } catch let error {
            print("Error occured while fetching, error == \(error.localizedDescription)")
        }
        return LoginManagerConstant.blankValue
    }
    
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error {
            print("Contect not saved, error == \(error.localizedDescription)")
        }
    }
    
    func isDatabaseEmpty() -> Bool {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managerObjectContext = appDelegate?.persistentContainer.viewContext else { return true}
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: LoginManagerConstant.entityName)
        do {
            let result = try managerObjectContext.fetch(fetchRequest)
            return result.count > 0 ? false : true
        } catch let error {
            print("Error occured while fetching, error == \(error.localizedDescription)")
        }
        return true
    }
}
