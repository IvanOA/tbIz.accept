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

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_phone: UILabel!
    @IBOutlet weak var lb_char: UILabel!
    @IBOutlet weak var viewChar: UIView!
    
    
}


extension String.CharacterView {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
extension UIColor {
    @nonobjc static var rayfColor: UIColor {
        let color = UIStyle.hexStringToUIColor(hex: "fafa00")
        return color
    }
}

class UIStyle {
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class Contact {
    var name: String
    var surname: String?
    var phone: String = ""
    init(name: String, phone: String, surname: String?){
        self.name = name
        self.surname = surname
        self.phone = phone
    }
}

class MainVC: UIViewController{
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var lb_nav_subtitle: UILabel!
    
    let a=3
    var contactStore = CNContactStore()
    let creditcard = CreditCard()
    var contactsRaf = [Contact]()
    //var profiles = [Profiles]()
    var store = CNContactStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id_card: UInt64 = 4952163892034721
        let CVC: Int = 283
        let name = "Никита"
        tableView.delegate = self
        topView.backgroundColor = UIColor.rayfColor
        LoadData.loadCreditCards(id_card: id_card, CVC: CVC)
        LoadData.loadCreditCards(id_card: id_card)
        LoadData.getCreditCard(phonenum: "89163680935")
        lb_nav_subtitle.text = "Выберете аккаунт\nдля подтверждения доверия"
        lb_nav_subtitle.sizeToFit()
        getContacts()
        //findContacts()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getContacts(){
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
                    for item in PersonalData.profiles {
                        if item.phone_number == phonenumber{
                            let contactRaf = Contact(name: contact.givenName, phone: phonenumber, surname: contact.familyName)
                            contactsRaf.append(contactRaf)
                        }
                    }
                    print(contactname)
                    print(phonenumber)
                }
                
            }
        }
    }
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.characters.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
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
        return contactsRaf.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContact", for: indexPath) as! ContactCell
        
        let name = contactsRaf[indexPath.row].name
        cell.lb_name.text = "\(name)"
        print(name)
        let char = name.characters.first
        cell.lb_char.text = "\(String(describing: char!))"
        if contactsRaf[indexPath.row].surname != nil{
            let surname = contactsRaf[indexPath.row].surname
            if surname != "" {
            cell.lb_name.text = "\(name) \(surname!)"
            for char2 in (surname?.characters)!{
                print(char2)
            }
            let char1 = surname?.characters.first!
            
            cell.lb_char.text = "\(String(describing: char1!))"
            print(String(describing: char1))
            }
            else{
                print("ravno empty")
            }
        }
        else {
            print("ravno nil")
        }
        print(String(describing: char))
        
        let number = format(phoneNumber: contactsRaf[indexPath.row].phone)
        cell.lb_phone.text = contactsRaf[indexPath.row].phone
        
        
        
        cell.viewChar.backgroundColor = UIColor.rayfColor
        cell.viewChar.alpha = 1
        cell.viewChar.layer.cornerRadius = cell.viewChar.frame.height/2
        return cell
    }
    
}
