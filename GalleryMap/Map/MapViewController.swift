//
//  MapViewController.swift
//  GalleryMap
//
//  Created by 三谷淳史 on 2018/12/02.
//  Copyright © 2018年 atsushi.mitani. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MyMapView!
    
    private var needInitView = false
    
    private let needLoadFromFirestore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setup()
        mapView.initLocationManager()
        
        // Firestoreからデータ取得
        let db = Firestore.firestore()
        db.collection("galleries").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let gallery = Gallery(id: document.documentID, data: document.data())
                    self.mapView.drawGalleryMarker(gallery: gallery)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
