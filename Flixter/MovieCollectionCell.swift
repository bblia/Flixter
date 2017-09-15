//
//  MovieCollectionCell.swift
//  Flixter
//
//  Created by Lia Zadoyan on 9/15/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
        
       override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
