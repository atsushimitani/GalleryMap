//
//  MapView.swift
//  GalleryMap
//
//  Created by 三谷淳史 on 2018/12/10.
//  Copyright © 2018年 atsushi.mitani. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MyMapView: GMSMapView, GMSMapViewDelegate, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoom: Float = 15.0
    
    var didInitView = false
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
 
    func setup() {
        isMyLocationEnabled = true
        mapType = GMSMapViewType.normal
        settings.compassButton = true
        settings.myLocationButton = true
        delegate = self
    }
    
    func initLocationManager() {
        // TODO 位置情報を取得できない場合の対応
        
        // 位置情報関連の初期化
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 50
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !didInitView {
            // 初期描画時のマップ中心位置の移動
            let camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: zoom)
            self.camera = camera
            locationManager?.stopUpdatingLocation()
            didInitView = true
        }
    }
    
    // ギャラリーのマーカーを描画
    func drawGalleryMarker(gallery: Gallery) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: gallery.latitude!, longitude: gallery.longitude!)
        marker.title = gallery.name
        var snipetText = ""
        for genre in gallery.genres {
            snipetText += "\(genre) "
        }
        marker.snippet = snipetText
        marker.map = self
    }
}
