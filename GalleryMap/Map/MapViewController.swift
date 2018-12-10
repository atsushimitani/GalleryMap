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
        
        // loadmapinfoメソッドに切り出して、オリジナルクラスに移す
        // Firestoreからデータ取得
        let db = Firestore.firestore()
        db.collection("galleries").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // データ取得
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let gallery = document.data()
                    
                    // TODO データをオブジェクトに格納

                    // マーカーを描画
                    let marker = GMSMarker()
                    let coordinate = gallery["coordinate"] as? GeoPoint
                    marker.position = CLLocationCoordinate2D(
                        latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
                    marker.title = gallery["name"] as? String
                    var snipet = ""
                    if let genres = gallery["genre"] as? [String] {
                        for genre in genres {
                            snipet += "\(genre) "
                        }
                    }
                    marker.snippet = snipet
                    marker.map = self.mapView
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
