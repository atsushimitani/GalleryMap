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

class MapViewController: UIViewController, MyMapViewDelegate {
    
    @IBOutlet weak var mapView: MyMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.myMapViewDelegate = self
        
        mapView.setup()
        mapView.initLocationManager()
        
        // buttonを表示するs
        let button = UIButton(frame: CGRect(x: 10, y: 35, width: 100, height: 30))
        button.setTitle("都市を選択", for: .normal)
//        button.addTarget(self, action: #selector(showCitiesOption()), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        
        // Firestoreからデータ取得
        let db = Firestore.firestore()
        db.collection("galleries").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let gallery = GalleryEntity(id: document.documentID, data: document.data())
                    self.mapView.drawGalleryMarker(gallery: gallery)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Markerの情報ウィンドウをタップした際の動作
    func tapInfoWindow(galleryId: String) {
        let detailStoryboard: UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
        
        if let detailViewController = detailStoryboard.instantiateInitialViewController() as? DetailViewController {
            // 詳細画面に遷移する
            detailViewController.setGalleryId(id: galleryId)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    // 都市選択のプルダウンを表示
    @objc func showCitiesOption() {

    }
    
}
