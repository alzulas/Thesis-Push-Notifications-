//
//  experimenterViews.swift
//  pusherSwiftTest
//
//  Created by Leah Zulas on 3/7/17.
//  Copyright © 2017 Leah Zulas. All rights reserved.
//

import UIKit
import UserNotifications

class experimenterViews: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setDeviceTokenToScreen()
        UserIDText.text = userIDfromvc
        UserIDText.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var userIDfromvc = String()

    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromExperimenter", sender: self)
    }
    
    @IBAction func userID(_ sender: UITextField) {
        UserIDText.text = sender.text
        print("set by entering data ", UserIDText.text!)
        userIDfromvc = String(UserIDText.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // remove keyboard on Return
        return false // do default behavior? (no difference here)
    }
    
    @IBOutlet weak var UserIDText: UITextField!
    @IBOutlet weak var deviceTokenID: UILabel!
    
    func setDeviceTokenToScreen(){
        //deviceTokenID.text = AppDelegate.setToken(AppDelegate)
    }
    
    

    
}
