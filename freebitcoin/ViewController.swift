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
                DispatchQueue.main.async {
                    // Create Date Picker
                    let datePicker: UIDatePicker = UIDatePicker()
                    datePicker.frame = CGRect(x: 0, y: self.webView.frame.height - 200, width: self.webView.frame.width, height: 200)
                    datePicker.datePickerMode = .countDownTimer
                    datePicker.countDownDuration = 60 * 60
                    datePicker.backgroundColor = UIColor.white
                    datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
                    datePicker.tag = 1 // Id to remove it later
                    
                    // Create Toolbar for 'done' button
                    let flexiblespace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace , target: nil, action: nil)
                    let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissPicker))
                    let barAccessory = UIToolbar(frame: CGRect(x: 0, y: self.webView.frame.height - 240, width: self.webView.frame.width, height: 44))
                    barAccessory.barStyle = .default
                    barAccessory.isTranslucent = true
                    barAccessory.items = [flexiblespace,btnDone]
                    barAccessory.tag = 2 // Id to remove it later
                  
                    self.webView.addSubview(datePicker)
                    self.webView.addSubview(barAccessory)
                }
                
                
//                // Schedule Notification
//                let content = UNMutableNotificationContent()
//                content.title = "Notification"
//                content.body = "Hello From Kavsoft !!!"
//
//                // this time interval represents the delay time of notification
//                // ie., the notification will be delivered after the delay.....
//
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//                let request = UNNotificationRequest(identifier: "noti", content: content, trigger: trigger)
//                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

                return
            } else {
                let alert = UIAlertController(title: "Error", message: "The notifications are disabled, please enable it in settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//                    TODO
//                    Open Settings
                }))
                
                DispatchQueue.main.async {
                  self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Not called the first time
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        print("Selected value \(sender.countDownDuration)")
    }
    
    @objc func dismissPicker() {
        print("Done")
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag = self.view.viewWithTag(2) {
            viewWithTag.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


