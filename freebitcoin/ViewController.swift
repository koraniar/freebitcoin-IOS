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
    var secondsForNotification: double_t!
    
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
                    datePicker.setValue(UIColor.black, forKeyPath: "textColor")
                    datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
                    datePicker.tag = 1 // Id to remove it later
                    
                    let calendar = Calendar.current
                    var components = DateComponents()
                    components.day = 1
                    components.month = 1
                    components.year = 2000
                    components.hour = 1
                    components.minute = 0
                    let newDate = calendar.date(from: components)
                    datePicker.setDate(newDate ?? Date(), animated: true)
                    
                    // Create Toolbar for 'done' button
                    let flexiblespace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace , target: nil, action: nil)
                    let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissPicker))
                    let barAccessory = UIToolbar(frame: CGRect(x: 0, y: self.webView.frame.height - 240, width: self.webView.frame.width, height: 44))
                    barAccessory.barStyle = .default
                    barAccessory.isTranslucent = true
                    barAccessory.items = [flexiblespace,btnDone]
                    barAccessory.tag = 2 // Id to remove it later
                  
                    self.secondsForNotification = 3600
                    self.webView.addSubview(datePicker)
                    self.webView.addSubview(barAccessory)
                }
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
        if sender.countDownDuration > 3600 {
            sender.countDownDuration = 3600
        }
        secondsForNotification = sender.countDownDuration
    }
    
    @objc func dismissPicker() {
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag = self.view.viewWithTag(2) {
            viewWithTag.removeFromSuperview()
        }
        
        // Schedule Notification
        let content = UNMutableNotificationContent()
        content.title = "Freebitco.in"
        content.body = "The game is ready to play"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsForNotification, repeats: false)

        let request = UNNotificationRequest(identifier: "freebit-1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        // Confirm Time
        let alert = UIAlertController(title: "Success", message: "Notification will appear in \(String(describing: secondsForNotification)) seconds.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


