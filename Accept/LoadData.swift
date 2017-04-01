//
//  LoadData.swift
//  Accept
//
//  Created by Иван on 01.04.17.
//  Copyright © 2017 Иван. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Profile:Object{
    dynamic var id_profile: UInt32 = 0
    dynamic var name: String = ""
    dynamic var surname: String = ""
    dynamic var phone_number: String = ""
    override static func primaryKey() -> String?{
        return "id_profile"
    }
}
class CreditCard:Object {
    dynamic var id_card: UInt64 = 0
    dynamic var owner: String = ""
    dynamic var date: String = ""
    dynamic var CVC: Int = 0
    dynamic var amount: Float = 0
    dynamic var isDefault: Bool = false
    dynamic var profile: Profile?
    override static func primaryKey() -> String?{
        return "id_card"
    }
}
class History: Object {
    dynamic var id_event: UInt32 = 0
    dynamic var sent_card_id: CreditCard?
    dynamic var rec_card_id: CreditCard?
    dynamic var trust_sum: Float = 0
    dynamic var spend_sum: Float = 0
    override static func primaryKey() -> String?{
        return "id_event"
    }
}

class LoadData {
    static func loadCreditCards(){
        //let data = require("./cards_data.json")
        //JSON(
        do {
        if let file = Bundle.main.url(forResource: "cards_data", withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = JSON(data: data)
            for (_,subJson):(String, JSON) in json{
                print(subJson["Card_Id"].stringValue)
            }
        }
        } catch {
            print(error.localizedDescription)
        }
    }
    static func loadProfiles(){

        do {
            if let file = Bundle.main.url(forResource: "users_data", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = JSON(data: data)
                for (_,subJson):(String, JSON) in json{
                    print(subJson["Phone_Num"].stringValue)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
