//
//  MapVC.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-28.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapVC: UIViewController ,CLLocationManagerDelegate{


    @IBOutlet weak var map: MKMapView!
    
    var gardenIndex:Int?
    let ref=Database.database().reference()
    let manager=CLLocationManager()
    // we pass the garden info from CropListVC to here
    var garden:MyGarden?
    var address:String?
    var gardenLocation:CLLocationCoordinate2D?
    //this function is called whenever User update their location
    
 /*   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.03, 0.03)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation=true
        
        
    }  */
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  manager.delegate=self
        manager.desiredAccuracy=kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()*/
        self.garden = SHARED_GARDEN_LIST[self.gardenIndex!]!
        
        guard let address = self.garden?.address else
            {
                print("invalid address")
                return
            }
        print(address)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.03, 0.03)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            self.gardenLocation = myLocation
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            self.map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = myLocation
            annotation.title = self.garden?.gardenName
            
            
            self.map.addAnnotation(annotation)
            // Use your location
        }
    }
    
    @IBAction func showMapAPP(_ sender: Any) {
       
        
        let regionDistance:CLLocationDistance = 1000
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(gardenLocation!, regionDistance, regionDistance )
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: gardenLocation!)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name=self.garden?.gardenName
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    func GetCoordinate(address: String){
        
    }

}
