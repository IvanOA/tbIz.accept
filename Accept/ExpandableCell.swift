//
//  ExpandableCell.swift
//  Accept
//
//  Created by Иван on 02.04.17.
//  Copyright © 2017 Иван. All rights reserved.
//

import UIKit

class ExpandableCell: UITableViewCell {

    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_given: UILabel!
    @IBOutlet weak var lb_minus: UILabel!
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var lb_cardnumber: UILabel!
    @IBOutlet weak var lb_datestatus: UILabel!
    @IBOutlet weak var lb_permission: UILabel!
    @IBOutlet weak var lb_status: UILabel!
    
    var hiddenlabels = [UILabel]()
    
    func expandedLabels(){
        hiddenlabels = [lb_cardnumber,lb_datestatus,lb_permission,lb_minus,lb_date,lb_status]
    }
    func fillLabels(events: [History], index: Int) {
        let sumtext: String = "\(Int(events[index].spend_sum)) / \(Int(events[index].trust_sum))"
//        var myMutableString = NSMutableAttributedString()
//        
//        myMutableString = NSMutableAttributedString(string: sumtext, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
//        
//        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location: <#T##Int#>, length: <#T##Int#>)
//        lb_given.attributedText = myMutableString
        lb_given.text = sumtext
        lb_datestatus.text = "Бессрочные"
        lb_status.text = "Yes"
        var card = String(events[index].rec_card_id)
        //card.startIndex = 11
        card = card.padding(toLength: 4, withPad: "1234567890", startingAt: 11)
        
        /*//characters.substring(start: 12, offsetBy: 16)))"*/
        lb_cardnumber.text = "**** \(card)"
        print(card)
        //}
        
        guard let profile = LoadData.loadCreditCards(id_card: events[index].rec_card_id) else{
            lb_name.text = "**** \(card)"
            return
        }
        lb_name.text = "\(profile.name) \(profile.surname.characters.first!)."
        
    }
//    var isExpanded: Bool = false{
//        didSet{
//            if isExpanded{
//                //hiddenlabels = self.expandedLabels()
//                for label in hiddenlabels {
//                    label.isHidden = false
//                    backgroundColor = UIColor.white
//                    
//                }
//            }else{
//                //hiddenlabels = self.expandedLabels()
//                for label in hiddenlabels {
//                    label.isHidden = true
//                    backgroundColor = UIColor.white
//                }
//            }
//        }
//    }
    
}
