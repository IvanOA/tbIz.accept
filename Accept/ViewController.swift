//
//  ViewController.swift
//  Accept
//
//  Created by Иван on 01.04.17.
//  Copyright © 2017 Иван. All rights reserved.
//

import UIKit
//import AddressBook
import Contacts
class Contact {
    var name: String = ""
    var phone: String = ""
    init(name: String, phone: String){
        self.name = name
        self.phone = phone
    }
}

class MainVC: UIViewController{
    
    
    @IBOutlet var tableView: UITableView!
    
    let a=3
    var contactStore = CNContactStore()
    let creditcard = CreditCard()
    var contacts = [Contact]()
    //var profiles = [Profiles]()
    var store = CNContactStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id_card: UInt64 = 4952163892034721
        let CVC: Int = 123
        
        tableView.delegate = self
        
        LoadData.loadCreditCards(id_card: id_card, CVC: CVC)
        let array = getContacts()
        for (phone,name) in array {
            let contact = Contact(name: name, phone: phone)
            contacts.append(contact)
            print("name: \(name), phone number: \(phone)")
        }
        //findContacts()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getContacts() -> [String:String]{
        var contactsContainProfile = [String:String]()
        var contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            return results
        }()
        for contact in contacts{
            let contactname = "\(contact.givenName) \(contact.familyName)"
            for phoneNumber in contact.phoneNumbers{
                if let number = phoneNumber.value as? CNPhoneNumber,
                    let label = phoneNumber.label {
                    //let localizedLabel = CNLabeledValue.localizedString(forLabel: label)
                    let phonenumber = removeSpecialCharsFromString(text: number.stringValue)
                    let flag = LoadData.loadProfiles(phone: phonenumber)
                    if flag == true{
                        contactsContainProfile[phonenumber] = contactname
                    }
                    print(" \(phonenumber)")
                }
                
            }
        }
        return contactsContainProfile
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("1234567890+".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    func findContacts() {
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        
        // The container means
        // that the source the contacts from, such as Exchange and iCloud
        var allContainers: [CNContainer] = []
        do {
            allContainers = try store.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var contacts: [CNContact] = []
        
        // Loop the containers
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try store.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                // Put them into "contacts"
                contacts.append(contentsOf: containerResults)
                
            } catch {
                print("Error fetching results for container")
            }
        }
        for contact in contacts {
            print(contact.namePrefix)
            for number in contact.phoneNumbers{
                print(number)
            }
        }
        
    }
        
}
//extension MainVC: ProfileDelegate{
//
//}

extension MainVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContact", for: indexPath)
        cell.textLabel?.text = contacts[indexPath.row].name
        return cell
    }
    
}
