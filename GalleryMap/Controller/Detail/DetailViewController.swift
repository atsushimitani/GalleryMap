//
//  DetailViewController.swift
//  GalleryMap
//
//  Created by 三谷淳史 on 2018/12/11.
//  Copyright © 2018年 atsushi.mitani. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {

    @IBOutlet weak private var nameLabel: UILabel!
    
    @IBOutlet weak private var genreLabel: UILabel!
    
    @IBOutlet weak private var urlLabel: UILabel!
    
    private(set) var galleryId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let galleryId : String = self.galleryId else {return}
   
        // Firestoreからデータ取得
        let db = Firestore.firestore()
        let docRef = db.collection("galleries").document(galleryId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let gallery = GalleryEntity(id: galleryId, data: document.data()!)
                self.loadGalleryDetail(gallery: gallery)
            } else {
                print("Document does not exist")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setGalleryId(galleryId: String) {
        self.galleryId = galleryId
    }
    
    // ギャラリー情報表示
    private func loadGalleryDetail(gallery: GalleryEntity) {
        self.nameLabel.text = gallery.name
        
        // ジャンル名を半角スペース区切りで表示
        var genreText = ""
        for genre in gallery.genres {
            genreText += "\(genre) "
        }
        self.genreLabel.text = genreText
        
        self.urlLabel.text = gallery.url
    }
}
