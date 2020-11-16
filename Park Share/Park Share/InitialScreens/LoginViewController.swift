//
//  ViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 10/11/20.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.stopAnimating()
        email.delegate = self
        password.delegate = self
        
        keychain.accessGroup = "Z254ZTLSS9.com.benalexander.Park-Share"
        
        checkIfLoggedIn()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func checkIfLoggedIn() {
        if let email = keychain.get("email"), let password = keychain.get("password") {
            if email != "" && password != "" {
                Variables.user.setUsername(username: keychain.get("username")!)
                Variables.user.setEmail(email: keychain.get("email")!)
                Variables.user.setPassword(password: keychain.get("password")!)
                Variables.user.setUserID(userID: Int64(keychain.get("id")!)!)
                Variables.user.setVenmo(venmo: keychain.get("venmo")!)
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "tabController")
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        if email.text! != "" && password.text! != "" {
            activity.startAnimating()
            enableInteraction(enable: false)
            
            let urlStr = Variables.baseURL + "checkUser/" + email.text! + "/" + password.text!
            let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "GET")
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data else { return }
                
                let result = JSON(data).dictionaryValue
                self.handleLoginResponse(response: result)
            }
            task.resume()
        }
        else {
            let alert = UIAlertController(title: "A field is empty", message: "Try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleLoginResponse(response: [String: JSON]) {
        DispatchQueue.main.async {
            self.activity.stopAnimating()
            self.enableInteraction(enable: true)
            if response.count > 0 {
                Variables.user.setUsername(username: response["username"]!.stringValue)
                Variables.user.setEmail(email: response["email"]!.stringValue)
                Variables.user.setPassword(password: response["password"]!.stringValue)
                Variables.user.setUserID(userID: response["id"]!.int64Value)
                Variables.user.setVenmo(venmo: response["venmo"]!.stringValue)
                
                self.keychain.set(response["username"]!.stringValue, forKey: "username")
                self.keychain.set(response["email"]!.stringValue, forKey: "email")
                self.keychain.set(self.password.text!, forKey: "password")
                self.keychain.set(String(response["id"]!.int64Value), forKey: "id")
                self.keychain.set(response["venmo"]!.stringValue, forKey: "venmo")
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "tabController")
                self.present(vc, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Email or password incorrect", message: "Try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alert, animated: true, completion: nil)
                self.enableInteraction(enable: true)
            }
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let alert = UIAlertController(title: "Enter your account email", message: nil, preferredStyle: .alert)
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Email"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { action in
            let email = alert.textFields![0] as UITextField
            
            let urlStr = Variables.baseURL + "sendEmail/" + email.text!
            let request = self.prepareHTTPRequest(urlStr: urlStr, httpMethod: "GET")
            self.activity.startAnimating()
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data else {
                        self.activity.stopAnimating()
                        return
                    }
                    
                    let result = JSON(data).dictionaryValue
                    let userID = result["userID"]!.int64Value
                    self.activity.stopAnimating()
                    
                    if userID == -1 {
                        let noAccountAlert = UIAlertController(title: "There is no account with the email " + email.text!, message: "Try again", preferredStyle: .alert)
                        noAccountAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self.present(noAccountAlert, animated: true, completion: nil)
                    }
                    else {
                        let vc = self.storyboard!.instantiateViewController(identifier: "forgotPasswordViewController") as ForgotPasswordViewController
                        vc.code = result["code"]!.stringValue
                        vc.userID = userID
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
            task.resume()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func enableInteraction(enable: Bool) {
        login.isUserInteractionEnabled = enable
        createAccount.isUserInteractionEnabled = enable
    }
}

extension UIViewController {
    func prepareHTTPRequest(urlStr: String, httpMethod: String) -> URLRequest {
        let loginString = String(format: "%@:%@", Variables.serverUsername, Variables.serverPW)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
