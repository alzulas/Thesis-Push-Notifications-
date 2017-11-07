//
//  ViewController.swift
//  pusherSwiftTest
//
//  Created by Leah Zulas on 2/25/17.
//  Copyright © 2017 Leah Zulas. All rights reserved.
//

/////////////////////////////////////////////////////////////////////////////////////////
//			This program retreives notifications from APNs utilizing Amanda Leah Zulas's Personal Team
//			A .js file utilizing NODE .js sends notifications to this application
//          This program is optimized for iOS 10 and Swift 3
//			This program is a part of a thesis project which is a small part of
//			the WSU Solar Decathlon Smart Home project, to compete October 2017
//			Orginal Author: Leah Zulas, Ph.D.
//			Additional Resources:
//          https://github.com/node-apn/node-apn
//			https://eladnava.com/send-push-notifications-to-ios-devices-using-xcode-8-and-swift-3/
//          https://blog.pusher.com/how-to-send-ios-10-notifications-using-the-push-notifications-api/
//          https://useyourloaf.com/blog/local-notifications-with-ios-10/
//          https://www.raywenderlich.com/1948/itunes-tutorial-for-ios-how-to-integrate-itunes-file-sharing-with-your-ios-app
//          http://askexpertpro.com/25090/solved-how-to-export-core-data-to-csv-in-swift-by-askexpertpro
//			Please direct all questions and comments to alzulas@hotmail.com
//			Please leave proper documentation for any new code, as well as the authors name
//			Enjoy
/////////////////////////////////////////////////////////////////////////////////////////

//Some code snippets borrowed from Larry Holder
//Thanks for all the help!

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    var notificationsOkay: Bool = false
    var deviceTokenInVC = "Not Set"
    var userIDint = "000"
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var userIDvc: UILabel!
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) { //This button lets the .txt file be sent to the experimenter
        
        let filename = getDocumentsDirectory().appendingPathComponent("notificationsData.txt")
        let fileURL = NSURL(fileURLWithPath: filename)
        let objectsToShare = [fileURL]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @IBAction func Useful(_ sender: UIButton) { //pressed useful button
        //print("Useful")
        
        if messageLabel.text != "No Message"{ //Don't print if it says no message
            let dateString = getDateString()//Get date
            let actionTaken = "Useful"//Get action
            let sendingText = String(stringInterpolation: dateString, " , ", actionTaken, ", ", messageLabel.text!, "\n")
            writeAFile(text: sendingText) //write a file
        }
        messageLabel.text = "No Message" //Change label so it no longer says notification
        
    }
    
    @IBAction func notUseful(_ sender: UIButton) { //pressed not useful button
        //print("Not Useful")
        
        if messageLabel.text != "No Message"{ //Don't print if it says no message
            let dateString = getDateString()//Get date
            let actionTaken = "NotUseful"//Get action
            let sendingText = String(stringInterpolation: dateString, " , ", userIDint, ", ", actionTaken, ", ", messageLabel.text!, "\n")
            writeAFile(text: sendingText) //write a file
        }
        messageLabel.text = "No Message" //change label so it no longer says notification
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("vdl: auth = \(notificationsOkay)")
        if (notificationsOkay) {
            print("vdl: notifications okay")
        } else {
            print("vdl: notifications not okay")
        }
        messageLabel.text = "No message"
        
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0
        
        userIDvc.text = "User: \(userIDint)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //settings may have changed. 
    func checkIfNotificationsStillOkay() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: self.handleNotificationSettings)
    }
    
    //function to get the path for the documents directory
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    //Collect the date, change it to Pacific time.
    //Would work out time zones, but it really doesn't matter for this study.
    func getDateString() -> String{
        let date = Date()
        let date1 = date.addingTimeInterval(-(60*60*8))
        let dateString = String(describing: date1)
        return dateString
    }
    
    func writeAFile(text: String){
        
        let file = "notificationsData.txt" //this is the file. we will write to and read from it
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(file)
            let pathString = getDocumentsDirectory().appendingPathComponent("notificationsData.txt")
            
            if FileManager.default.fileExists(atPath: pathString){ //if file exists
                var fileHandle: FileHandle? = nil
                do {
                    fileHandle = try FileHandle(forWritingTo: path)
                } catch {
                    print("Error with fileHandle")
                }
                if fileHandle != nil { //if fileHandler exists
                    fileHandle!.seekToEndOfFile()
                    let csvData = text.data(using: String.Encoding.utf8, allowLossyConversion: false) //append to file
                    fileHandle!.write(csvData!)
                    fileHandle!.closeFile()
                }
            }else{ //If file doesn't exist
                do {
                    try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)//make new file
                }
                catch {
                    print("Error creating file")
                }
            }
        }
    }
    
    //check for notification settings available to application
    func handleNotificationSettings (notificationSettings: UNNotificationSettings) {
        if ((notificationSettings.alertSetting == .enabled) &&
            (notificationSettings.badgeSetting == .enabled) &&
            (notificationSettings.soundSetting == .enabled)) {
            self.notificationsOkay = true
            print("notifications enabled")
        } else {
            self.notificationsOkay = false
            print("notifications disabled")
        }
    }
    
    @IBAction func toExperiment(_ sender: UIButton) {
        performSegue(withIdentifier: "toExperimenterView", sender: nil) // sender could also be the button (sender) or self
        print("to experiment")
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toExperimenterView") {
            let viewController = segue.destination as! experimenterViews
           viewController.userIDfromvc = userIDint //pass current user ID to experimenter view for display in the text field
        }
    }
    
    @IBAction func unwindFromExperimenterView (sender: UIStoryboardSegue) {
        let experimenterView = sender.source as! experimenterViews
        //print("inside unwind ", experimenterView.userIDfromvc)
        userIDvc.text = String("User: \(experimenterView.userIDfromvc)") //Reset the user label in main view
        userIDint = experimenterView.userIDfromvc //reset the variable that fills the label on restart
        
    }
    
}

