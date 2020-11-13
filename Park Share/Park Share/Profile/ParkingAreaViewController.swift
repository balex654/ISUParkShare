//
//  ParkingAreaViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 11/1/20.
//

import UIKit

class ParkingAreaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleEditing: UIButton!
    
    var areas: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getParkingAreas()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkingAreaTableViewCell", for: indexPath) as! ParkingAreaTableViewCell
        
        cell.address.text = areas[indexPath.row]["address"] as? String
        cell.numSpots.text = "Spots Available: " + String((areas[indexPath.row]["numSpots"] as? Int)!)
        cell.price.text = "Price Per Spot (USD): " + String((areas[indexPath.row]["price"] as? Double)!)
        let notes = areas[indexPath.row]["notes"] as? String
        cell.notes.text = "Notes: " + notes!
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteArea(indexPath: indexPath)
        }
    }
    
    func getParkingAreas() {
        let urlStr = Variables.baseURL + "getParkingAreas/" + String(Variables.user.getUserID())
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "GET")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    self.activity.stopAnimating()
                    return
                }
                
                let result = JSON(data).arrayValue
                self.areas = []
                for r in result {
                    var area: [String: Any] = [:]
                    area["id"] = r["id"].int64Value
                    area["address"] = r["address"].stringValue
                    area["numSpots"] = r["num_spots"].intValue
                    area["price"] = r["price_per_spot"].doubleValue
                    area["notes"] = r["notes"].stringValue
                    self.areas.append(area)
                }
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    @IBAction func addArea(_ sender: Any) {
        let alert = UIAlertController(title: "Add Parking Area", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Address"
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Number of Spots"
            UITextField.keyboardType = .numberPad
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Price Per Spot"
            UITextField.keyboardType = .decimalPad
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Notes"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            let address = alert.textFields![0] as UITextField
            let numSpots = alert.textFields![1] as UITextField
            let price = alert.textFields![2] as UITextField
            let notes = alert.textFields![3] as UITextField
            
            if address.text! == "" || numSpots.text! == "" || price.text! == "" {
                alert.message = "A FIELD IS EMPTY"
                self.present(alert, animated: true, completion: nil)
            }
            else {
                DispatchQueue.main.async {
                    self.addAreaPost(address: address.text!, numSpots: numSpots.text!, price: price.text!, notes: notes.text!)
                    self.activity.startAnimating()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addAreaPost(address: String, numSpots: String, price: String, notes: String) {
        var urlStr = Variables.baseURL + "addParkingArea?"
        urlStr += "user_id=" + String(Variables.user.getUserID())
        urlStr += "&address=" + address
        urlStr += "&num_spots=" + numSpots
        urlStr += "&price_per_spot=" + price
        urlStr += "&notes=" + notes
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "POST")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let _ = data else {
                    self.activity.stopAnimating()
                    return
                }
                
                self.getParkingAreas()
            }
        }
        task.resume()
    }
    
    func deleteArea(indexPath: IndexPath) {
        let urlStr = Variables.baseURL + "removeParkingArea/" + String((areas[indexPath.row]["id"] as? Int64)!)
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "DELETE")
        areas.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let _ = data else { return }
        }
        task.resume()
    }
    
    @IBAction func toggleEditing(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        toggleEditing.setTitle(tableView.isEditing ? "Done" : "Remove Parking Area", for: .normal)
    }
    
}
