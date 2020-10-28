//
//  ProfileViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 10/28/20.
//

import UIKit
import KeychainSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var venmo: UILabel!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.text = Variables.user.getUsername()
        email.text = Variables.user.getEmail()
        venmo.text = Variables.user.getVenmo()
        
        keychain.accessGroup = "Z254ZTLSS9.com.benalexander.Park-Share"
    }

    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            
            // Clear the user from Variables and keychain
            Variables.user = UserInfo.init()
            
            self.keychain.set("", forKey: "email")
            self.keychain.set("", forKey: "password")
            self.keychain.set("", forKey: "username")
            self.keychain.set("", forKey: "id")
            self.keychain.set("", forKey: "venmo")
            
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
