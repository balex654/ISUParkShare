//
//  CurrentVehiclesViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 11/12/20.
//

import UIKit

class CurrentVehiclesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var info: [[String: Any]] = []
    var listedAreaId: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Renters In This Area"
        getVehicles()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentVehiclesTableViewCell", for: indexPath) as! CurrentVehiclesTableViewCell
        
        cell.makeAndModel.text = (info[indexPath.row]["make"] as! String) + " " + (info[indexPath.row]["model"] as! String)
        cell.color.text = "Color: " + (info[indexPath.row]["color"] as! String)
        cell.plateNumber.text = "Plate Number: " + (info[indexPath.row]["plateNumber"] as! String)
        cell.username.text = "Owned By: " + (info[indexPath.row]["username"] as! String)
        
        return cell
    }
    
    func getVehicles() {
        let urlStr = Variables.baseURL + "getVehiclesInArea/" + String(listedAreaId)
        let request = prepareHTTPRequest(urlStr: urlStr, httpMethod: "GET")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {
                    self.activity.stopAnimating()
                    return
                }
                
                let result = JSON(data).arrayValue
                for r in result {
                    var i: [String: Any] = [:]
                    i["make"] = r["make"].stringValue
                    i["model"] = r["model"].stringValue
                    i["plateNumber"] = r["plate_number"].stringValue
                    i["username"] = r["username"].stringValue
                    i["color"] = r["color"].stringValue
                    self.info.append(i)
                }
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
        task.resume()
    }

}
