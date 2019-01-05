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
    
    @IBOutlet weak var urlTextView: UITextView!
    
    private(set) var galleryId: String? = nil
    
    private var gallery : GalleryEntity? = nil

    @IBAction func handleBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let galleryId = self.galleryId else {return}
        
        urlTextView.isSelectable = true
        urlTextView.isEditable = false
        
        // Firestoreからデータ取得
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        let docRef = db.collection("galleries").document(galleryId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.gallery = GalleryEntity(id: galleryId, data: document.data()!)
                self.showDetail(gallery: self.gallery!)
            } else {
                print("Document does not exist")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setGalleryId(id galleryId: String) {
        self.galleryId = galleryId
    }
    
    // ギャラリー情報表示
    private func showDetail(gallery: GalleryEntity) {
        nameLabel.text = gallery.name
        
        // ジャンル名を半角スペース区切りで表示
        var genreText = ""
        for genre in gallery.genres {
            genreText += "\(genre) "
        }
        genreLabel.text = genreText
        
        if let url = gallery.url {
            urlTextView.text = url
            urlTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openUrl)))
        }
    }
    
    @objc func openUrl() {
        if let urlString = gallery!.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
