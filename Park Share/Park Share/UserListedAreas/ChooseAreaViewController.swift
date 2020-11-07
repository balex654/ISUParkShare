//
//  ChooseAreaViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 11/7/20.
//

import UIKit

class ChooseAreaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    var areas: [[String: Any]] = []
    var areaSelected: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAreas()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseAreaTableViewCell", for: indexPath) as! ChooseAreaTableViewCell
        cell.address.text = areas[indexPath.row]["address"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        areaSelected = areas[indexPath.row]
    }
    
    func getAreas() {
        let urlStr = Variables.baseURL + "getParkingAreas/" + String(Variables.user.getUserID())
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "GET")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    self.activity.stopAnimating()
                    return
                }
                
                let result = JSON(data).arrayValue
                for r in result {
                    var area: [String: Any] = [:]
                    area["address"] = r["address"].stringValue
                    area["id"] = r["id"].int64Value
                    self.areas.append(area)
                }
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    @IBAction func submit(_ sender: Any) {
        if areaSelected.isEmpty {
            alert(message: "No address was selected")
        }
        else if startDate.date >= endDate.date {
            alert(message: "The start date is later than the end date")
        }
        else {
            let urlStr = Variables.baseURL + "getUserListedParking/" + String(Variables.user.getUserID())
            let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "GET")
            activity.startAnimating()
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data else {
                        self.activity.stopAnimating()
                        return
                    }
                    
                    let result = JSON(data).arrayValue
                    for r in result {
                        if r["id"].int64Value == self.areaSelected["id"] as! Int64 {
                            self.alert(message: "You've already listed this address")
                            self.activity.stopAnimating()
                            return
                        }
                    }
                    self.commitAreaListing()
                }
            }
            task.resume()
        }
    }
    
    func commitAreaListing() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let startDateStr = dateFormatter.string(from: startDate.date)
        let endDateStr = dateFormatter.string(from: endDate.date)
        
        var urlStr = Variables.baseURL + "addListedParking?"
        urlStr += "area_id=" + String(areaSelected["id"] as! Int64)
        urlStr += "&user_id=" + String(Variables.user.getUserID())
        urlStr += "&spot_taken=0"
        urlStr += "&start_time=" + startDateStr + ":00"
        urlStr += "&end_time=" + endDateStr + ":00"
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "POST")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let _ = data else {
                    self.activity.stopAnimating()
                    return
                }
                self.dismiss(animated: true, completion: nil)
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
