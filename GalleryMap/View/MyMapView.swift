//
//  MyMapView.swift
//  GalleryMap
//
//  Created by 三谷淳史 on 2018/12/10.
//  Copyright © 2018年 atsushi.mitani. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol MyMapViewDelegate {
    func tapInfoWindow(galleryId :String)
}

class MyMapView: GMSMapView, GMSMapViewDelegate, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var placesClient: GMSPlacesClient!
    private var zoom: Float = 15.0
    
    private var didInitView = false
    
    var myMapViewDelegate: MyMapViewDelegate?
 
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
    
    // 位置情報の更新があった場合の処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !didInitView {
            // 初期描画時のマップ中心位置の移動
            let camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: zoom)
            self.camera = camera
            locationManager?.stopUpdatingLocation()
            didInitView = true
        }
    }
    
    // マーカーの情報ウィンドウがタップされた際の処理
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let userData = marker.userData as! [String:String]
        let id = userData["id"];
        
        myMapViewDelegate?.tapInfoWindow(galleryId: id!)
    }

    // マーカーを描画
    func drawGalleryMarker(gallery: GalleryEntity) {
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(latitude: gallery.latitude!, longitude: gallery.longitude!)
        marker.title = gallery.name
        
        var snipetText = ""
        for genre in gallery.genres {
            snipetText += "\(genre) "
        }
        marker.snippet = snipetText
        
        var userData = [String:String]()
        userData["id"] = gallery.id
        marker.userData = userData
        
        marker.map = self
    }
}
