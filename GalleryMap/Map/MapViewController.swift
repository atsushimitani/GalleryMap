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

    // MapViewに移したい
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var placesClient: GMSPlacesClient!
    private var zoom: Float = 15.0

    private var needInitView = false
    
    private let needLoadFromFirestore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        // ここから下はMapクラスに委譲できる
        initLocationManager()
        
        
        // TODO 位置情報を取得できない場合の対応
        
        
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
        
        // TODO: - Realm
        if (needLoadFromFirestore) {
//            loadMapInfo()
        } else {
//            loadMapInfo()
        }
    }
    
    private func setup() {
        mapView.isMyLocationEnabled = true
        mapView.mapType = GMSMapViewType.normal
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
    }
    
    // MARK: - Google Map Functions
    
    private func initLocationManager() {
        // 位置情報関連の初期化
        // MapViewに入れてもいいと思う
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 50
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        placesClient = GMSPlacesClient.shared()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // オリジナルクラスに移す
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !needInitView {
            // 初期描画時のマップ中心位置の移動
            let camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: zoom)
            mapView.camera = camera
            locationManager?.stopUpdatingLocation()
            needInitView = true
        }
    }

}
