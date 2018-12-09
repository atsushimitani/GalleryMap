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

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!

    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var placesClient: GMSPlacesClient!
    private var zoom: Float = 15.0

    private var initView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.isMyLocationEnabled = true
        self.mapView.mapType = GMSMapViewType.normal
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
        self.mapView.delegate = self

        // 位置情報関連の初期化
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.distanceFilter = 50
        self.locationManager?.startUpdatingLocation()
        self.locationManager?.delegate = self
        self.placesClient = GMSPlacesClient.shared()
        
        // TODO 位置情報を取得できない場合の対応
        
        // Firestoreからデータ取得
        let db = Firestore.firestore()
        db.collection("galleries").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // データ取得
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    var gallery = document.data()

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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !self.initView {
            // 初期描画時のマップ中心位置の移動
            let camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: self.zoom)
            self.mapView.camera = camera
            self.locationManager?.stopUpdatingLocation()
            self.initView = true
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
