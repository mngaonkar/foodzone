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
    @IBOutlet weak var lobsterLocationInfo: UILabel!
    
    var location: String!
    var lobsterType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateMapLocation()
        updateLocationInfo()
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
        
        mapLocation.text = self.location
        geocoder.geocodeAddressString(self.location) { (placemarks, error) in
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

    func updateLocationInfo(){
        let lobsterInfoText = "<h1>Your \(self.lobsterType!) lobster is sourced from exotic location of \(mapLocation.text as! String)</h1>"
        let attributeString = try? NSAttributedString(
            data: lobsterInfoText.data(using: String.Encoding.unicode)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        lobsterLocationInfo.attributedText = attributeString
    }
}
