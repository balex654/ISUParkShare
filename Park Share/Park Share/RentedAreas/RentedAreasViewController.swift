//
//  RentedAreasViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 11/12/20.
//

import UIKit

class RentedAreasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var areas: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRentedAreas()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RentedAreasTableViewCell", for: indexPath) as! RentedAreasTableViewCell
        cell.address.text = areas[indexPath.row]["address"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "AreaDetails") as! AreaDetailsViewController
        vc.addressStr = areas[indexPath.row]["address"] as! String
        vc.totalSpotsStr = "Total Spots Available: " + String((areas[indexPath.row]["spotsAvailable"] as? Int)!)
        vc.numTakenStr = "Number of Spots Taken: " + String((areas[indexPath.row]["spotsTaken"] as? Int)!)
        vc.startDateStr = "Start Date: " + (areas[indexPath.row]["startDate"] as? String)!
        vc.endDateStr = "End Date: " + (areas[indexPath.row]["endDate"] as? String)!
        vc.priceStr = "Price per Spot: $" + String((areas[indexPath.row]["price"] as? Double)!)
        vc.usernameStr = "Listed By: " + (areas[indexPath.row]["username"] as? String)!
        vc.venmoStr = "Venmo Username: " + (areas[indexPath.row]["venmo"] as? String)!
        vc.notesStr = "Notes: " + (areas[indexPath.row]["notes"] as? String)!
        
        vc.fromRentedAreas = true
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func getRentedAreas() {
        let urlStr = Variables.baseURL + "getRentedAreas/" + String(Variables.user.getUserID())
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
                    area["address"] = r["address"].stringValue
                    area["spotsAvailable"] = r["num_spots"].intValue
                    area["spotsTaken"] = r["spot_taken"].intValue
                    area["startDate"] = self.convertDate(date: r["start_time"].stringValue)
                    area["endDate"] = self.convertDate(date: r["end_time"].stringValue)
                    area["price"] = r["price_per_spot"].doubleValue
                    area["notes"] = r["notes"].stringValue
                    area["username"] = r["username"].stringValue
                    area["venmo"] = r["venmo_username"].stringValue
                    area["id"] = r["id"].int64Value
                    self.areas.append(area)
                }
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func convertDate(date: String) -> String {
        var subDate = date.prefix(19)
        subDate += "-0600"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let originalDate = dateFormatter.date(from: String(subDate))
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let newDateStr = dateFormatter.string(from: originalDate!)
        return newDateStr
    }
}
