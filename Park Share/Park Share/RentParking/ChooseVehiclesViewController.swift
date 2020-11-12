//
//  ChooseVehiclesViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 11/11/20.
//

import UIKit

class ChooseVehiclesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var vehicles: [[String: Any]] = []
    var selectedRows: [Int] = []
    var spotsAvailable = 0
    var listedAreaId: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVehicles()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseVehiclesTableViewCell", for: indexPath) as! ChooseVehiclesTableViewCell
        cell.makeAndModel.text = (vehicles[indexPath.row]["make"] as! String) + " " + (vehicles[indexPath.row]["model"] as! String)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows.append(indexPath.row)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var i = 0
        for r in selectedRows {
            if r == indexPath.row {
                selectedRows.remove(at: i)
            }
            i += 1
        }
    }
    
    func getVehicles() {
        let urlStr = Variables.baseURL + "getUserVehicles/" + String(Variables.user.getUserID())
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "GET")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    self.activity.stopAnimating()
                    return
                }
                
                let result = JSON(data).arrayValue
                self.vehicles = []
                for r in result {
                    var vehicle: [String: Any] = [:]
                    vehicle["make"] = r["make"].stringValue
                    vehicle["model"] = r["model"].stringValue
                    vehicle["id"] = r["id"].int64Value
                    self.vehicles.append(vehicle)
                }
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    @IBAction func rent(_ sender: Any) {
        if selectedRows.count == 0 {
            alert(message: "You must select at least one vehicle")
        }
        else if selectedRows.count > spotsAvailable {
            alert(message: "There aren't enough spots available for that many vehicles")
        }
        else {
            let urlStr = Variables.baseURL + "/updateNumSpots/" + String(listedAreaId) + "/" + String(selectedRows.count)
            let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "PUT")
            activity.startAnimating()
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                DispatchQueue.main.async {
                    guard let _ = data else {
                        self.activity.stopAnimating()
                        return
                    }
                    
                    self.commitRentalRelation()
                }
            }
            task.resume()
        }
    }
    
    func commitRentalRelation() {
        let urlStr = Variables.baseURL + "/userRentedArea/" + String(listedAreaId)
        var request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "POST")
        
        var jsonArray: [Int64] = []
        for r in selectedRows {
            jsonArray.append(vehicles[r]["id"] as! Int64)
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let _ = data else {
                    self.activity.stopAnimating()
                    return
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        task.resume()
    }
    
    func alert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
