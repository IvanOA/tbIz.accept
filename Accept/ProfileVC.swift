//
//  ProfileVC.swift
//  Accept
//
//  Created by Иван on 02.04.17.
//  Copyright © 2017 Иван. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_status: UILabel!
    @IBOutlet weak var lb_sumAmount: UILabel!
    @IBOutlet weak var lb_card: UILabel!
    @IBOutlet weak var lb_name_guest1: UILabel!
    @IBOutlet weak var lb_amount_guest1: UILabel!
    @IBOutlet weak var lb_name_guest2: UILabel!
    @IBOutlet weak var lb_amount_guest2: UILabel!
    @IBOutlet weak var lb_restguests: UILabel!
    
    @IBOutlet weak var bn_sumManager: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    //vars
    
    var history = [History]()
    var selectedCell = Int()
    var profile = PersonalData.profile
    //var card = PersonalData.creditcard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCard()
        tableView.delegate = self
        tableView.dataSource = self
        topView.backgroundColor = UIColor.rayfColor
        cardView.backgroundColor = UIColor.clear
        history = LoadData.loadHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showCard(){
        let card: CreditCard = PersonalData.creditcard
        lb_name.text = card.owner
        var card1 = String(card.id_card)
        //card.startIndex = 11
        card1 = card1.padding(toLength: 4, withPad: "1234567890", startingAt: 11)
        lb_card.text = "**** \(card1)"
        lb_status.text = "Доступно"
        lb_sumAmount.text = "\(Int(card.amount))"
        
    }
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGiven", for: indexPath) as! ExpandableCell
//        if selectedCell != indexPath.row {
//            cell.isExpanded = true
//            // paint the last cell tapped to white again
//            
//            //self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectedCell, inSection: 0))?.backgroundColor = UIColor.whiteColor()
//            // save the selected index
//            self.selectedCell = indexPath.row
//            
//            // paint the selected cell to gray
//            //self.tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.gray
//            
//            // update the height for all the cells
//            self.tableView.beginUpdates()
//            self.tableView.endUpdates()
        
    }
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGiven", for: indexPath) as! ExpandableCell
//        cell.isExpanded = false
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGiven", for: indexPath) as! ExpandableCell
        //cell.isExpanded = false
        cell.expandedLabels()
        cell.fillLabels(events: history, index: indexPath.row)
        //cell.isExpanded = false
        return cell
    }
}
