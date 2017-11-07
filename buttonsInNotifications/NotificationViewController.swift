//
//  NotificationViewController.swift
//  buttonsInNotifications
//
//  Created by Leah Zulas on 3/1/17.
//  Copyright © 2017 Leah Zulas. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    
    //This code allows buttons to happen, because we need a specific kind of framework for it to be possible.
    @IBOutlet var label: UILabel?
    
    @IBOutlet weak var subtitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        self.subtitle?.text = notification.request.content.subtitle
    }
}
