//
//  CreateAccountViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 10/21/20.
//

import UIKit
import KeychainSwift

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var venmo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    let pwInfoAlert = UIAlertController(title: "Your password must have:\nat least 8 characters\nno spaces\nat least one number\n at least one letter", message: nil, preferredStyle: .alert)
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.stopAnimating()
        
        username.delegate = self
        email.delegate = self
        venmo.delegate = self
        password.delegate = self
        confirm.delegate = self
        
        keychain.accessGroup = "Z254ZTLSS9.com.benalexander.Park-Share"
    }
    
    func textFieldShouldReturn(_ firstName: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
    
    func checkInputSizes() -> String {
        if username.text!.count > 50 {
            return "Username character count limit of 30 exceeded"
        }
        else if email.text!.count > 100 {
            return "Email character count limit of 50 exceeded"
        }
        else if password.text!.count > 200 {
            return "Password character count limit of 200 exceeded"
        }
        else if venmo.text!.count > 50 {
            return "Venmo username character count limit of 50 exceeded"
        }
        else {
            return ""
        }
    }

    @IBAction func create(_ sender: Any) {
        if username.text! == "" || email.text! == "" || venmo.text! == "" || password.text! == "" || confirm.text! == "" {
            let alert = UIAlertController(title: "A field is empty", message: "Try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else if username.text!.contains(" ") || email.text!.contains(" ") {
            let alert = UIAlertController(title: "No spaces allowed in the username or email", message: "Enter something different", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else if !checkPassword(pw: password.text!) {
            pwInfoAlert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(pwInfoAlert, animated: true, completion: nil)
        }
        else if checkInputSizes().count > 0 {
            let alert = UIAlertController(title: checkInputSizes(), message: "Please enter a something shorter", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else if password.text != confirm.text {
            let alert = UIAlertController(title: "Your passwords don't match", message: "Try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            checkUniqueness()
        }
    }
    
    func checkUniqueness() {
        create.isUserInteractionEnabled = false
        activity.startAnimating()
        
        var urlStr = Variables.baseURL + "checkUniqueness/"
        urlStr += username.text! + "/" + email.text! + "/" + venmo.text!
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "GET")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    self.create.isUserInteractionEnabled = true
                    self.activity.stopAnimating()
                    return
                }
                let result = String(data: data, encoding: .utf8)
                
                if result == self.username.text! {
                    self.create.isUserInteractionEnabled = true
                    self.activity.stopAnimating()
                    let alert = UIAlertController(title: "That username already exists", message: "Try another", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                else if result == self.email.text! {
                    self.create.isUserInteractionEnabled = true
                    self.activity.stopAnimating()
                    let alert = UIAlertController(title: "An account with that email already exists", message: "Try another", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                else if result == self.venmo.text! {
                    self.create.isUserInteractionEnabled = true
                    self.activity.stopAnimating()
                    let alert = UIAlertController(title: "An account with that Venmo username already exists", message: "Try another", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.createUser()
                }
            }
        }
        task.resume()
    }
    
    func createUser() {
        var urlStr = Variables.baseURL + "createUser?"
        urlStr += "username=" + username.text!
        urlStr += "&email=" + email.text!
        urlStr += "&password=" + password.text!
        urlStr += "&venmo=" + venmo.text!
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "POST")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    self.create.isUserInteractionEnabled = true
                    self.activity.stopAnimating()
                    return
                }
                
                self.create.isUserInteractionEnabled = true
                self.activity.stopAnimating()
                let result = String(data: data, encoding: .utf8)
                self.handleResponse(response: result!)
            }
        }
        task.resume()
    }
    
    func handleResponse(response: String) {
        Variables.user.setUsername(username: username.text!)
        Variables.user.setEmail(email: email.text!)
        Variables.user.setPassword(password: password.text!)
        Variables.user.setVenmo(venmo: venmo.text!)
        Variables.user.setUserID(userID: Int64(response)!)
        
        self.keychain.set(username.text!, forKey: "username")
        self.keychain.set(email.text!, forKey: "email")
        self.keychain.set(password.text!, forKey: "password")
        self.keychain.set(response, forKey: "id")
        self.keychain.set(venmo.text!, forKey: "venmo")
        
        username.text = ""
        email.text = ""
        password.text = ""
        confirm.text = ""
        venmo.text = ""
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "tabController")
        self.present(vc, animated: true, completion: nil)
    }
    
}
