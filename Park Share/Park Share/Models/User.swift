//
//  User.swift
//  Park Share
//
//  Created by Ben Alexander on 10/21/20.
//

import Foundation

class UserInfo {
    private var username: String
    private var email: String
    private var password: String
    private var userID: Int64
    private var venmo: String
    
    init() {
        self.username = ""
        self.email = ""
        self.password = ""
        self.userID = -1
        self.venmo = ""
    }
    
    init(username: String, email: String, password: String, userID: Int64, venmo: String) {
        self.username = username
        self.email = email
        self.password = password
        self.userID = userID
        self.venmo = venmo
    }
    
    func getUsername() -> String {
        return username
    }
    func setUsername(username: String) {
        self.username = username
    }
    
    func getEmail() -> String {
        return email
    }
    func setEmail(email: String) {
        self.email = email
    }
    
    func getPassword() -> String {
        return password
    }
    func setPassword(password: String) {
        self.password = password
    }
    
    func getUserID() -> Int64 {
        return userID
    }
    func setUserID(userID: Int64) {
        self.userID = userID
    }
    
    func getVenmo() -> String {
        return venmo
    }
    func setVenmo(venmo: String) {
        self.venmo = venmo
    }
}
