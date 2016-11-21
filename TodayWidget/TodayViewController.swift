//
//  TodayViewController.swift
//  todayWidget
//
//  Created by Rajtharan Gopal on 11/11/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var widgetTimeLabel: UILabel!
    @IBOutlet weak var expiryTimeLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults(suiteName: "group.com.mallowtech.TodayWidgetExtension")
        if let accessToken = defaults?.object(forKey: "accessToken") as? String {
            loginButton.setTitle("Log out", for: .normal)
        } else {
            loginButton.setTitle("Log in", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // User tapped on the widget. Open the application using the specified URL Scheme.
        let appURL = NSURL(string: "StarterApplication://")
        if loginButton.title(for: .normal) == "Log out" {
            let sharedSuite = UserDefaults(suiteName: "group.com.mallowtech.TodayWidgetExtension")!
            sharedSuite.removeObject(forKey: "accessToken")
            sharedSuite.removeObject(forKey: "timeExpiry")
            sharedSuite.removeObject(forKey: "timeString")
            sharedSuite.synchronize()
        }
        self.extensionContext?.open(appURL! as URL, completionHandler:nil)
    }
    
    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        widgetTimeLabel?.text = "Still not sure"
        expiryTimeLabel?.text = "Still not sure"
        
            let defaults = UserDefaults(suiteName: "group.com.mallowtech.TodayWidgetExtension")
            if let timeString:String = defaults?.object(forKey: "timeString") as? String {
                widgetTimeLabel.text = "You last ran app at: " + timeString
            }
            if let expiryString = defaults?.object(forKey: "timeExpiry") as? String {
                expiryTimeLabel.text = "You access token expires at: " + expiryString
            }
            completionHandler(NCUpdateResult.newData)
        }
}

