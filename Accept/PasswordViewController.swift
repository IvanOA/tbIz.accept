//
//  PasswordViewController.swift
//  Accept
//
//  Created by Волков Никита on 01.04.17.
//  Copyright © 2017 Иван. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    
    @IBOutlet weak var password_unconfirmed: UITextField!
    @IBOutlet weak var password_confirmed: UITextField!
    @IBOutlet weak var bt_confirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func bt_confirm_Action(_ sender: UIButton) {
        if (password_confirmed.text != nil) && (password_unconfirmed.text != nil) && (password_confirmed.text==password_unconfirmed.text)
        {
    performSegue(withIdentifier: "PasswordEntry", sender: self)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
}
