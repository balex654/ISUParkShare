//
//  AllParkingViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 11/9/20.
//

import UIKit

class AllParkingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var areas: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAreas(group: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllParkingTableViewCell", for: indexPath) as! AllParkingTableViewCell
        
        cell.address.text = areas[indexPath.row]["address"] as? String
        cell.spotsAvailable.text = "Total Spots Available: " + String((areas[indexPath.row]["spotsAvailable"] as? Int)!)
        cell.spotsTaken.text = "Number of Spots Taken: " + String((areas[indexPath.row]["spotsTaken"] as? Int)!)
        cell.startDate.text = "Start Date: " + (areas[indexPath.row]["startDate"] as? String)!
        cell.endDate.text = "End Date: " + (areas[indexPath.row]["endDate"] as? String)!
        
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
        
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        let group = DispatchGroup()
        group.enter()
        getAreas(group: group)
        
        group.notify(queue: .main) {
            refreshControl.endRefreshing()
        }
    }
    
    func getAreas(group: DispatchGroup?) {
        let urlStr = Variables.baseURL + "getAllListedParking"
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
                    self.areas.append(area)
                }
                self.activity.stopAnimating()
                self.tableView.reloadData()
                
                if group != nil {
                    group!.leave()
                }
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
