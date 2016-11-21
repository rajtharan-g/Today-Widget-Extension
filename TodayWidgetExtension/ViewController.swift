//
//  ViewController.swift
//  TodayWidgetExtension
//
//  Created by Rajtharan Gopal on 11/11/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit
import TodayWidgetNetworkKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var expiryTime: UILabel!
    
    //var timeLabel: UILabel?
    var timer: Timer?
    let INTERVAL_SECONDS = 1
    var accessToken: String?
    var expires: String?
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed))
        loadTimer()
        DispatchQueue.main.async {
           let timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.INTERVAL_SECONDS),
                                target: self,
                                selector: #selector(self.updateTimeLabel),
                                userInfo: nil,
                                repeats: true)
        }
        loadAccessToken()
        loadExpiryTime()
    }
    
    func loadAccessToken() {
        if let accessToken = self.accessToken {
            //expiryTime.text = accessToken
            let defaults = UserDefaults(suiteName: "group.com.mallowtech.TodayWidgetExtension")
            defaults?.set(accessToken, forKey: "accessToken")
            defaults?.synchronize()
        }
    }
    
    func loadExpiryTime() {
        if let expires = self.expires {
            let dateOfExpiry = dateFormatter.string(from:  NSDate(timeIntervalSinceNow: Double(expires)! / 1000) as Date)
            expiryTime.text = "Access token expires at: " + dateOfExpiry
            let defaults = UserDefaults(suiteName: "group.com.mallowtech.TodayWidgetExtension")
            defaults?.set(String(dateOfExpiry), forKey: "timeExpiry")
            defaults?.synchronize()
        }
    }
    
    func loadTimer() {
        // set up date formatter since it's expensive to keep creating them
        self.dateFormatter.dateStyle = DateFormatter.Style.medium
        self.dateFormatter.timeStyle = DateFormatter.Style.medium
        updateTimeLabel()
    }
    
    func updateTimeLabel() {
        let now = NSDate()
        let dateString = dateFormatter.string(from: now as Date)
        timeLabel.text = dateString
        let defaults = UserDefaults(suiteName:"group.com.mallowtech.TodayWidgetExtension")
        defaults?.set(dateString, forKey: "timeString")
        defaults?.synchronize()
    }
    
    func logoutPressed() {
            timer?.invalidate()
            let sharedSuite = UserDefaults(suiteName: "group.com.mallowtech.TodayWidgetExtension")!
            sharedSuite.removeObject(forKey: "accessToken")
            sharedSuite.removeObject(forKey: "timeExpiry")
            sharedSuite.removeObject(forKey: "timeString")
            sharedSuite.synchronize()
            self.navigationController?.popToRootViewController(animated: true)
    }
    
}
    


