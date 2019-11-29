//
//  ImageCollectionViewCell.swift
//  lab13
//
//  Created by yenifer santiago  on 11/21/19.
//  Copyright © 2019 yenifer santiago . All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil 
    }
    
}
