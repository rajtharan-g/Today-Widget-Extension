//
//  LoginViewController.swift
//  TodayWidgetExtension
//
//  Created by Rajtharan Gopal on 11/11/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        loginNetworkRequest { (error, expires, accessToken) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print(error.localizedDescription)
            } else {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "Dashboard") as! ViewController
                vc.expires = expires
                vc.accessToken = accessToken
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func loginNetworkRequest(completion: @escaping (NSError?, String?, String?) -> Void) {
        let params = ["access_key": "f5875fa5f7bcc14e51b1930eea224f4f",
                      "secret_key": "30afb2a580523bab82ffcd72e285fc48",
                      "app_id": "com.mallowtech.TodayWidgetExtension",
                      "device_id": "936489958030b3c1be1b1f8848d856140c260f51"]
        
        guard let url = NSURL(string: "https://rest.cricketapi.com/rest/v2/auth/") else {
            return
        }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        let stringParams = paramsString(parameters: params)
        let dataParams = stringParams.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.httpBody = dataParams
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                completion(error as NSError?, nil, nil)
            }
            guard let data = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? AnyObject
                let auth = json?["auth"] as? [String : String]
                print(json)
                if let accessToken =  auth?["access_token"] {
                    if let expires = auth?["expires"] {
                        completion(nil, expires, accessToken)
                    }
                } else {
                    completion(error as NSError?, nil, nil)
                }
            } catch {
                // Do nothing
            }
        }
        task.resume()
    }
    
    func paramsString(parameters: [String : String]) -> String {
        var paramsString = [String]()
        for (key, value) in parameters {
            guard let stringValue = value as? String, let stringKey = key as? String else {
                return ""
            }
            paramsString += [stringKey + "=" + "\(stringValue)"]
            
        }
        return (paramsString.isEmpty ? "" : paramsString.joined(separator: "&"))
    }
    
}

//extension Dictionary {
//    
//    func paramsString() -> String {
//        var paramsString = [String]()
//        for (key, value) in self {
//            guard let stringValue = value as? String, let stringKey = key as? String else {
//                return ""
//            }
//            paramsString += [stringKey + "=" + "\(stringValue)"]
//            
//        }
//        return (paramsString.isEmpty ? "" : paramsString.joined(separator: "&"))
//    }
//    
//}

