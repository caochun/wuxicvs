//
//  CVSMapViewController.swift
//  WuxiCVS
//
//  Created by Chun Cao on 2016/11/23.
//  Copyright © 2016年 Nemoworks. All rights reserved.
//

import UIKit
import MapKit

class CVSMapViewController: UIViewController, MKMapViewDelegate {
    
    var json: JSON = JSON.null

    @IBOutlet weak var cvsMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cvsMapView.delegate = self
        
        var cvsList = [CVSAnnotation]()
        
        if let file = Bundle.main.path(forResource: "cvs", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: file))
                let json = JSON(data: data)
                self.json = json
                
                if json.type == .array {
                    let cvss = json.arrayValue
                    for cvs in cvss{
                        let name = cvs["name"].stringValue
                        let addr = cvs["address"].stringValue
                        let lati = cvs["latitude"].stringValue
                        let longitude = cvs["longitude"].stringValue
                        
                        
                        cvsList.append(CVSAnnotation(title: name, coordinate: CLLocationCoordinate2D(latitude: Double(lati)!,longitude:Double(longitude)!), info: addr))
                    }
                    
                }
            } catch {
                self.json = JSON.null
            }
        } else {
            self.json = JSON.null
        }
    
        
        cvsMapView.addAnnotations(cvsList)
        
        let visibleMap = findApporiateRegion(annotations: cvsList)
        
        cvsMapView.setRegion(MKCoordinateRegion(center: visibleMap.0, span: visibleMap.1), animated: true)
    }
    
    
    
    func findApporiateRegion(annotations: [CVSAnnotation]) ->  (CLLocationCoordinate2D,MKCoordinateSpan){
        
        var maxLat: CLLocationDegrees = 0.0
        var minLat: CLLocationDegrees = 360
        var maxLon: CLLocationDegrees = 0.0
        var minLon: CLLocationDegrees = 360
        
        for annotation in annotations{
            let location = annotation.coordinate
            
            if location.latitude > maxLat{
                maxLat = location.latitude
            }
            
            if location.latitude < minLat{
                minLat = location.latitude
            }
            
            if location.longitude > maxLon {
                maxLon = location.longitude
            }
            
            if location.longitude < minLon {
                minLon = location.longitude
            }
        }
        
        let center  = CLLocationCoordinate2D(latitude: (maxLat + minLat)/2, longitude: (maxLon + minLon)/2)
        
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.2, longitudeDelta: (maxLon - minLon)*1.2)
        
        return (center, span)
        
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let annotation = annotation as? CVSAnnotation {
//            let identifier = "pin"
//            var view: MKPinAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//                as? MKPinAnnotationView {
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                // 3
//                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//            }
//            return view
//        }
//        return nil
//
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
