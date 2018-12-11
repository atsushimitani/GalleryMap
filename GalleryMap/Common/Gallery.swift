//
//  Gallery.swift
//  GalleryMap
//
//  Created by 三谷淳史 on 2018/12/11.
//  Copyright © 2018年 atsushi.mitani. All rights reserved.
//

import Firebase

class Gallery: NSObject {

    var id: String?
    var name: String?
    var url: String?
    var genres: [String] = []
    var latitude: Double?
    var longitude: Double?
    
    init(id: String, data: [String:Any]) {
        self.id = id

        name = data["name"] as? String
        url = data["url"] as? String

        let coordinate = data["coordinate"] as? GeoPoint
        latitude = coordinate?.latitude
        longitude = coordinate?.longitude
        
        genres = data["genre"] as! [String]
    }

}

