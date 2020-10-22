//
//  ViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 10/11/20.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.stopAnimating()
        email.delegate = self
        password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
