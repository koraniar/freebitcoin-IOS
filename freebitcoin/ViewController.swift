//
//  ViewController.swift
//  freebitcoin
//
//  Created by Esteban Garcia Alvarez on 16/06/20.
//  Copyright © 2020 Esteban Garcia Alvarez. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://freebitco.in/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        let buttonFrame = CGRect(x: 50, y: 150, width: 50, height: 50)
        let button = UIButton(frame: buttonFrame)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(scheduleNotification(sender:)), for: .touchUpInside)
        webView.addSubview(button)
    }
    
    @objc func scheduleNotification(sender: UIButton) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (allowed, _) in
            if allowed {
                let content = UNMutableNotificationContent()
                content.title = "Notification"
                content.body = "Hello From Kavsoft !!!"

                // this time interval represents the delay time of notification
                // ie., the notification will be delivered after the delay.....

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                let request = UNNotificationRequest(identifier: "noti", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

                return
            } else {
                let alert = UIAlertController(title: "Error", message: "The notifications are disabled, please enable it in settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                
                DispatchQueue.main.async {
                  self.present(alert, animated: true, completion: nil)
                }

            }
        }
    }
}


