//
//  LoadData.swift
//  Accept
//
//  Created by Иван on 01.04.17.
//  Copyright © 2017 Иван. All rights reserved.
//

import Foundation
//import RealmSwift
import SwiftyJSON

final class PersonalData {
    static var profile = Profile()
    static var creditcard = CreditCard()
    static var profiles = [Profile]()
    //static let history = [History]()
}

class Profile{
    var id_profile: String = ""
    var name: String = ""
    var surname: String = ""
    var phone_number: String = ""
    var cardnumber: String = ""
    //static let profile = Profile()
    
}
class CreditCard{
    var id_card = UInt64()
    var owner: String = ""
    var date: String = ""
    var CVC: Int = 0
    var amount: Float = 0
    var isDefault: Bool = false
    var phone_number = String()
    var profile: Profile?
    //static let creditcard = CreditCard()
    
}
class History{
    var id_event: String = ""
    var sent_card_id = UInt64()
    var rec_card_id = UInt64()
    var trust_sum: Float = 0
    var spend_sum: Float = 0
    //var count_sum: Float = 0
    //static let event = History()
    
}

class LoadData {
    
    class func loadHistory() -> [History]{
        var events = [History]()
        do {
            if let file = Bundle.main.url(forResource: "history_data", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = JSON(data: data)
                //var i = 0
                for (_,subJson):(String, JSON) in json{
                    //event.id_event = "e\(i)"
                    let event = History()
                    event.rec_card_id = subJson["Rec_Card_Id"].uInt64Value
                    event.sent_card_id = subJson["Sent_Card_Id"].uInt64Value
                    event.spend_sum = subJson["Spent_Amount"].floatValue
                    event.trust_sum = subJson["Trust_Amount"].floatValue
                    events.append(event)
                    //i = i + 1
                }
                //return events
            }
            
        } catch {
            print(error.localizedDescription)
        }
        return events
        
    }
    class func loadCreditCards(id_card:UInt64)->Profile?{
        let profiles = PersonalData.profiles
        do {
            if let file = Bundle.main.url(forResource: "cards_data", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = JSON(data: data)
                for (_,subJson):(String, JSON) in json{
                    if id_card == UInt64(subJson["Card_Id"].stringValue){
                        
                        //print(PersonalData.creditcard.date)
                        let phonenum = subJson["Phone_number"].stringValue
                        for item in profiles{
                            if item.phone_number == phonenum {
                                return item
                            }
                        }
                    }
                    else{
                        // print("card number is wrong")
                    }
                }
                
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    class func getCreditCard(phonenum: String) {
        do {
            if let file = Bundle.main.url(forResource: "cards_data", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = JSON(data: data)
                for (_,subJson):(String, JSON) in json{
                    if phonenum == subJson["Phone_number"].stringValue{
                        
                        let card = CreditCard()
                        card.id_card = subJson["Card_Id"].uInt64Value
                        card.CVC = subJson["CVC"].intValue
                        print(card.id_card)
                        card.owner = subJson["Name"].stringValue
                        card.date = subJson["Valid_Date"].stringValue
                        card.phone_number = subJson["Phone_number"].stringValue
                        card.isDefault = true
                        card.amount = subJson["Money_Amount"].floatValue
                        PersonalData.creditcard = card
                        print(card.date)
                        break
                    
                    }
                }
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    class func loadCreditCards(id_card: UInt64, CVC: Int){
        
        do {
        if let file = Bundle.main.url(forResource: "cards_data", withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = JSON(data: data)
            for (_,subJson):(String, JSON) in json{
                if id_card == UInt64(subJson["Card_Id"].stringValue){
                    let owner = subJson["Name"].stringValue
                   // print("card is in database")
                    print("Owner: \(owner)")
                    if CVC == subJson[""].intValue {
                        print("CVC is correct")
                    }
                    else{
                        print("CVC is invalid")
                    }
                    break
                }
                else{
                   // print("card number is wrong")
                }
            }
            
        }
        } catch {
            print(error.localizedDescription)
        }
    }
//    func parseUnicide(string: String)->String{
//        //var str = string.components(separatedBy: "\u")
//        
//    }
    
    class func loadProfiles() {
        
        
        do {
            if let file = Bundle.main.url(forResource: "users_data", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = JSON(data: data)
                //var i = 0
                for (_,subJson):(String, JSON) in json{
                    let profile = Profile()
                    var name = subJson["Name"].stringValue
                    profile.cardnumber = subJson["Card"].stringValue
                    profile.phone_number = subJson["Phone_Num"].stringValue
                    print(profile.phone_number)
                    var surname = subJson["Surname"].stringValue
                    profile.name = name
                    profile.surname = surname
                    //profile.id_profile = "p\(i)
                    var flag: Bool = false
                    for item in PersonalData.profiles{
                        if item.phone_number == profile.phone_number {
                            flag = true
                            
                        }
                        
                    }
                    if flag == false{
                        PersonalData.profiles.append(profile)
                        print("new profile with name \(profile.surname) was added to database")
                    }
                    else{print("such profile alreay exists")}
                    
                }
                print("profiles were loaded succefully")
            }
        } catch {
            print(error.localizedDescription)
            
        }
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 10){
            self.loadProfiles()
        }
    }
}
