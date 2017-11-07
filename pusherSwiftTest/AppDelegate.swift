//
//  AppDelegate.swift
//  pusherSwiftTest
//
//  Created by Leah Zulas on 2/25/17.
//  Copyright © 2017 Leah Zulas. All rights reserved.
//

import UIKit
import UserNotifications

//import PusherSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let vc = self.window?.rootViewController as! ViewController
        
        //request for auth for notifications
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            vc.notificationsOkay = granted
            NSLog("notifications auth = \(granted)")
            NSLog("auth = \(vc.notificationsOkay)")
        }
        
        //creates buttons
        setActions()
        
        // Register with APNs
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //This is never called, because didReceive response clobbers it.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    
    //This method handles button presses from a notification. Including pressing the notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //This is a whole lot of code that parces the notification body out of the rest of the notification
        //This could be easier if didReceive response didn't clobber didReceiveRemoteNotification
        //If this is ever fixed by Apple, this could be modified to about 2 lines.
        let data = String(describing: response.notification)
        let range: Range<String.Index> = data.range(of: "body: ")!
        let myIndex: Int = data.distance(from: data.startIndex, to: range.upperBound)
        let range2 = data.index(data.startIndex, offsetBy: myIndex)
        let halfData = data.substring(from: range2)
        let range3: Range<String.Index> = halfData.range(of: ", categoryIdentifier")!
        let myIndex2: Int = halfData.distance(from: halfData.startIndex, to: range3.lowerBound)
        let range4 = halfData.index(halfData.startIndex, offsetBy: myIndex2)
        let finalString = halfData.substring(to: range4)
        print(finalString)
        
        let vc = self.window?.rootViewController as! ViewController //because I need something from the view controller
        vc.messageLabel.text = finalString //set the text in the main screen to the notification body
        //This is so that if the user clicks on the notification and it takes them to the app, they can still see it and decide if it was useful or not
        
        //Collect the date, change it to Pacific time.
        //Would work out time zones, but it really doesn't matter for this study.
        let date = Date()
        let date1 = date.addingTimeInterval(-(60*60*8))
        let dateString = String(describing: date1)
        //print(dateString)
        
        // Determine the user action, and you can handle it here too. Prints to the .txt file for now, then run SABLE outside of the app
        //Should be changed once we get a good policy for the reinforcement learner
        var actionTaken = "None"
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            actionTaken = "DismissAction"
            //print("Dismiss Action")//default clear, swipe right to left
        case UNNotificationDefaultActionIdentifier:
            actionTaken = "Default"
            //print("Default")//default go to app
        case "Useful":
            actionTaken = "Useful"
            //print("Useful") //special button, go to website
        case "NotUseful":
            actionTaken = "NotUseful"
            //print("Not Useful")//special dismiss button, but it does the same thing as above
        default:
            actionTaken = "Unknown"
            //print("Unknown action")//required to complete a switch statement.
        }
        let userID = vc.userIDint
        
        //Print the data to a .txt file
        let sendingText = String(stringInterpolation: dateString, " , ID: ", userID, ", " ,actionTaken, ", ", finalString, "\n")
        writeAFile(text: sendingText)
        //experimenterViews.userID(experimenterViews), ", "
        
        //Required to quit gracefully
        completionHandler()
    }
    
    //Push notification received
    //This function is clobbered by didReceive response
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print(data[AnyHashable("payload")]!)
    }
    
    //function to get the path for the documents directory
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    //Writes anything you hand it to a file. notificationsData.txt
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

    
    //allows notification to be seen when application in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NSLog("received notification while in foreground")
        completionHandler([.alert]) // no options, so silence notification
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        //Write it to a file
        writeAFile(text: "Device Token: ")
        writeAFile(text: deviceTokenString)
        writeAFile(text: "\n")
        
        //send it to vc to be passed to experimenter view.
        let vc = self.window?.rootViewController as! ViewController
        vc.deviceTokenInVC = deviceTokenString
        // Persist it in your backend in case it's new, although I can't right now, because I have no back end
    }
//    Note that the device token may change in the future due to various reasons, so use NSUserDefaults, a local key-value store, to persist the token locally and only update your backend when the token has changed, to avoid unnecessary requests.
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    
    //creates buttons for the notifications
    func setActions() {
        let Usefull = UNNotificationAction( //This is a button
            identifier: "Useful",
            title: "This notification was useful 👍",
            options: []
        )
        let NotUsefull = UNNotificationAction( //This is a button
            identifier: "NotUseful",
            title: "This notification was NOT useful 👎",
            options: []
        )
        let category = UNNotificationCategory( //This is the category of all the buttons
            identifier: "UserVote",
            actions: [Usefull, NotUsefull],
            intentIdentifiers: []
        )
        //Set category to the notifications center
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
    }
}




