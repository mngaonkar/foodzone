//
//  MapViewController.swift
//  foodzone
//
//  Created by mahadev gaonkar on 03/06/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateMapLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Update food location on map
    func updateMapLocation() {
        let geocoder = CLGeocoder()
        
        mapLocation.text = "San Francisco"
        geocoder.geocodeAddressString("San Francisco") { (placemarks, error) in
            if (error == nil){
                if let placemark = placemarks?.first {
                    let coordinate: CLLocationCoordinate2D = placemark.location!.coordinate
                
                    let annotation = MKPointAnnotation()
                    
                    //annotation.coordinate = CLLocationCoordinate2D(latitude: 37.806577, longitude: -122.405407)
                    annotation.coordinate = coordinate
                    self.mapView.addAnnotation(annotation)
                    self.mapView.setCenter(annotation.coordinate, animated: true)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
