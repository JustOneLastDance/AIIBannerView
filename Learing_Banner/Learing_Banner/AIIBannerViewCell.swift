//
//  AIIBannerViewCell.swift
//  Learing_Banner
//
//  Created by JustinChou on 2022/9/23.
//

import Foundation
import UIKit

class AIIBannerViewCell: UICollectionViewCell {
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(imageView!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
