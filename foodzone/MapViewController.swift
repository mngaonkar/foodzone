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
    
    var sourceLocation: String!
    var destinationLocation: String!
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
        let geocoder1 = CLGeocoder()
        let sourceAnnotation = MKPointAnnotation()
        let destinationAnnotation = MKPointAnnotation()
        
        mapLocation.text = "Journey"
        geocoder1.geocodeAddressString(self.sourceLocation) { (placemarks, error) in
            if (error == nil){
                if let placemark = placemarks?.first {
                    let coordinate: CLLocationCoordinate2D = placemark.location!.coordinate
                
                    //annotation.coordinate = CLLocationCoordinate2D(latitude: 37.806577, longitude: -122.405407)
                    sourceAnnotation.coordinate = coordinate
                    sourceAnnotation.title = "Lobster journey begins here - \(self.sourceLocation as String)"
                    self.mapView.addAnnotation(sourceAnnotation)
                    
                    //self.mapView.setCenter(sourceAnnotation.coordinate, animated: true)
                }
            }
        }
        
        let geocoder2 = CLGeocoder()
        geocoder2.geocodeAddressString(self.destinationLocation) { (placemarks, error) in
            if (error == nil){
                if let placemark = placemarks?.first {
                    let coordinate: CLLocationCoordinate2D = placemark.location!.coordinate
                    
                    destinationAnnotation.coordinate = coordinate
                    destinationAnnotation.title = "Lobster journey ends here - \(self.destinationLocation as String)"
                    self.mapView.addAnnotation(destinationAnnotation)
                    
                    //self.mapView.setCenter(destinationAnnotation.coordinate, animated: true)
                    self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
                }
            }
        }
    }

    func updateLocationInfo(){
        let lobsterInfoText = "<h1>Your \(self.lobsterType!) lobster is sourced from exotic location of <font color=\"green\">\(self.sourceLocation as! String)</font> and has travelled to its final destination of <font color=\"blue\">\(self.destinationLocation as! String)</font></h1>"
        let attributeString = try? NSAttributedString(
            data: lobsterInfoText.data(using: String.Encoding.unicode)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        lobsterLocationInfo.attributedText = attributeString
    }
}
