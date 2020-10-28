//
//  VehiclesViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 10/28/20.
//

import UIKit

class VehiclesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleEditing: UIButton!
    
    var cars: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCars()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleTableViewCell", for: indexPath) as! VehicleTableViewCell
        
        cell.makeModel.text = cars[indexPath.row]["makeModel"] as? String
        cell.color.text = cars[indexPath.row]["color"] as? String
        cell.plateNumber.text = cars[indexPath.row]["plateNumber"] as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteCar(indexPath: indexPath)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func getCars() {
        let urlStr = Variables.baseURL + "getUserVehicles/" + String(Variables.user.getUserID())
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "GET")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    self.activity.stopAnimating()
                    return
                }
                
                let result = JSON(data).arrayValue
                self.cars = []
                for r in result {
                    var car: [String: Any] = [:]
                    car["makeModel"] = r["make"].stringValue + " " + r["model"].stringValue
                    car["color"] = "Color: " + r["color"].stringValue
                    car["plateNumber"] = "Plate Number: " + r["plate_number"].stringValue
                    car["id"] = r["id"].int64Value
                    
                    self.cars.append(car)
                }
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    @IBAction func addVehicle(_ sender: Any) {
        let alert = UIAlertController(title: "Add Vehicle", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Make"
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Model"
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Color"
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Plate Number"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            let make = alert.textFields![0] as UITextField
            let model = alert.textFields![1] as UITextField
            let color = alert.textFields![2] as UITextField
            let plateNumber = alert.textFields![3] as UITextField
            
            if make.text! == "" || model.text! == "" || color.text! == "" || plateNumber.text! == "" {
                alert.message = "A FIELD IS EMPTY"
                self.present(alert, animated: true, completion: nil)
            }
            else {
                DispatchQueue.main.async {
                    self.addCar(make: make.text!, model: model.text!, color: color.text!, plateNumber: plateNumber.text!)
                    self.activity.startAnimating()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addCar(make: String, model: String, color: String, plateNumber: String) {
        var urlStr = Variables.baseURL + "addVehicle?"
        urlStr += "make=" + make
        urlStr += "&model=" + model
        urlStr += "&color=" + color
        urlStr += "&plate_number=" + plateNumber
        urlStr += "&user_id=" + String(Variables.user.getUserID())
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "POST")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let _ = data else {
                    self.activity.stopAnimating()
                    return
                }
                
                self.getCars()
            }
        }
        task.resume()
    }
    
    func deleteCar(indexPath: IndexPath) {
        let urlStr = Variables.baseURL + "removeVehicle/" + String((cars[indexPath.row]["id"] as? Int64)!)
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "DELETE")
        cars.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let _ = data else {
                return
            }
        }
        task.resume()
    }
    
    @IBAction func toggleEditing(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        toggleEditing.setTitle(tableView.isEditing ? "Done" : "Remove Vehicles", for: .normal)
    }
}
