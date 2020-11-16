//
//  ForgotPasswordViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 11/15/20.
//

import UIKit
import KeychainSwift

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterCode: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var triesIndicator: UILabel!
    @IBOutlet weak var requirements: UILabel!
    @IBOutlet weak var verifyCode: UIButton!
    @IBOutlet weak var setPassword: UIButton!
    
    var code = ""
    var userID: Int64 = -1
    var triesLeft = 5
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keychain.accessGroup = "Z254ZTLSS9.com.benalexander.Park-Share"
        triesIndicator.text = ""
        
        enterCode.delegate = self
        newPassword.delegate = self
        confirmPassword.delegate = self
        
        activity.stopAnimating()
        
        hideNewPassword(hide: true)
    }
    
    func textFieldShouldReturn(_ text: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @IBAction func verifyCode(_ sender: Any) {
        if enterCode.text == code {
            triesIndicator.text = "Verified! Enter your new password below"
            triesIndicator.textColor = UIColor(red: 0.12, green: 0.68, blue: 0, alpha: 1.0)
            
            enterCode.isUserInteractionEnabled = false
            verifyCode.isUserInteractionEnabled = false
            
            hideNewPassword(hide: false)
        }
        else if triesLeft == 1 {
            triesIndicator.text = "Incorrect code, remaining tries: 0"
            enterCode.isUserInteractionEnabled = false
            verifyCode.isUserInteractionEnabled = false
        }
        else {
            triesLeft -= 1
            triesIndicator.text = "Incorrect code, remaining tries: " + String(triesLeft)
        }
    }
    
    @IBAction func setPassword(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        if newPassword.text! != confirmPassword.text! {
            alert.title =  "New password and confirm new password don't match"
            alert.message = "Try again"
            self.present(alert, animated: true, completion: nil)
            alert.message = nil
        }
        else if !self.checkPassword(pw: newPassword.text!){
            alert.title = "A requirment below hasn't been met"
            self.present(alert, animated: true, completion: nil)
        }
        else if newPassword.text!.count > 200 {
            alert.title = "Password character count limit of 200 exceeded"
            self.present(alert, animated: true, completion: nil)
        }
        else {
            postNewPassword(password: newPassword.text!)
        }
    }
    
    func postNewPassword(password: String) {
        activity.startAnimating()
        setPassword.isUserInteractionEnabled = false
        
        let urlStr = Variables.baseURL + "modifyPassword/" + String(userID) + "/" + password
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "PUT")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let _ = data else {
                    self.activity.stopAnimating()
                    return
                }
            
                self.activity.stopAnimating()
                
                let alert = UIAlertController(title: "Password changed", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    func checkPassword(pw: String) -> Bool {
        if pw.count < 8 {
            return false
        }
        else if pw.contains(" ") {
            return false
        }
        
        var noLetters = true
        var noNumbers = true
        for x in pw.unicodeScalars {
            if CharacterSet.letters.contains(x) {
                noLetters = false
            }
            if CharacterSet.decimalDigits.contains(x) {
                noNumbers = false
            }
        }
        if noLetters || noNumbers {
            return false
        }
        return true
    }
    
    func hideNewPassword(hide: Bool) {
        newPassword.isHidden = hide
        confirmPassword.isHidden = hide
        requirements.isHidden = hide
        setPassword.isHidden = hide
        
        newPassword.isUserInteractionEnabled = !hide
        confirmPassword.isUserInteractionEnabled = !hide
        setPassword.isUserInteractionEnabled = !hide
    }
}
