//
//  DetailViewController.swift
//  GalleryMap
//
//  Created by 三谷淳史 on 2018/12/11.
//  Copyright © 2018年 atsushi.mitani. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak private var nameLabel: UILabel!
    
    @IBOutlet weak private var genreLabel: UILabel!
    
    @IBOutlet weak private var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
