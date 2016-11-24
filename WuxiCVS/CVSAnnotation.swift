//
//  CVSAnnotation.swift
//  WuxiCVS
//
//  Created by Chun Cao on 2016/11/23.
//  Copyright © 2016年 Nemoworks. All rights reserved.
//

import UIKit
import MapKit


class CVSAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = info
    }
}
