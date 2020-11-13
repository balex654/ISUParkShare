//
//  ListedAreasViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 11/1/20.
//

import UIKit

class ListedAreasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var listParking: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var areas: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getListedAreas(group: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListedAreasTableViewCell", for: indexPath) as! ListedAreasTableViewCell
        
        cell.address.text = areas[indexPath.row]["address"] as? String
        cell.spotsAvailable.text = "Total Spots Available: " + String((areas[indexPath.row]["spotsAvailable"] as? Int)!)
        cell.spotsTaken.text = "Number of Spots Taken: " + String((areas[indexPath.row]["spotsTaken"] as? Int)!)
        cell.startDate.text = "Start Date: " + (areas[indexPath.row]["startDate"] as? String)!
        cell.endDate.text = "End Date: " + (areas[indexPath.row]["endDate"] as? String)!
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CurrentVehicles") as! CurrentVehiclesViewController
        vc.listedAreaId = areas[indexPath.row]["listedAreaId"] as! Int64
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
        getListedAreas(group: group)
        
        group.notify(queue: .main) {
            refreshControl.endRefreshing()
        }
    }
    
    func getListedAreas(group: DispatchGroup?) {
        let urlStr = Variables.baseURL + "getUserListedParking/" + String(Variables.user.getUserID())
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
                    area["listedAreaId"] = r["id"].int64Value
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
