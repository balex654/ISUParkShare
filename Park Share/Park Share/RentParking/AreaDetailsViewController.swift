//
//  AreaDetailsViewController.swift
//  Park Share
//
//  Created by Ben Alexander on 11/9/20.
//

import UIKit
import MapKit

class AreaDetailsViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var totalSpots: UILabel!
    @IBOutlet weak var numTaken: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var venmo: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var rent: UIButton!
    
    var addressStr = String()
    var totalSpotsStr = String()
    var numTakenStr = String()
    var startDateStr = String()
    var endDateStr = String()
    var priceStr = String()
    var usernameStr = String()
    var venmoStr = String()
    var notesStr = String()
    
    var totalSpotsInt = 0
    var numTakenInt = 0
    var listedAreaId: Int64 = 0
    
    var fromRentedAreas = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    func initUI() {
        showLocation(address: addressStr)
        address.text = addressStr
        address.sizeToFit()
        totalSpots.text = totalSpotsStr
        numTaken.text = numTakenStr
        startDate.text = startDateStr
        endDate.text = endDateStr
        price.text = priceStr
        username.text = usernameStr
        venmo.text = venmoStr
        notes.text = notesStr
        notes.sizeToFit()
        
        if fromRentedAreas {
            rent.isHidden = true
            rent.isUserInteractionEnabled = false
        }
    }
    
    func showLocation(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) {(placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                return
            }
            
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            self.map.addAnnotation(annotation)
            
            let area = CLLocation(latitude: lat, longitude: lng)
            self.centerToLocation(area)
        }
    }
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func rent(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(identifier: "ChooseVehicles") as! ChooseVehiclesViewController
        vc.spotsAvailable = totalSpotsInt - numTakenInt
        vc.listedAreaId = self.listedAreaId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
