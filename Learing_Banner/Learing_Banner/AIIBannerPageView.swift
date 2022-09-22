//
//  AIIBannerPageView.swift
//  Learing_Banner
//
//  Created by JustinChou on 2022/9/23.
//

import Foundation
import UIKit
import Kingfisher

let kAIIBannerViewCellIdentifier = "kAIIBannerViewCellIdentifier"

class AIIBannerPageView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var urls: [String]?
    
    // 便利构造器是辅助型构造器，可以使用它跳用同一个类中的指定构造器，且可以为指定构造器提供特定参数
    // 在此处，为指定构造器提供了 layout 参数
    public convenience init(frame: CGRect, loop: Bool) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width, height: frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        register(AIIBannerViewCell.self, forCellWithReuseIdentifier: kAIIBannerViewCellIdentifier)
        backgroundColor = .white
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        bounces = false
    }
    
    func setUrls(_ urls: [String]) {
        self.urls = urls
        reloadData()
        layoutIfNeeded()
    }
}

extension AIIBannerPageView {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAIIBannerViewCellIdentifier, for: indexPath) as! AIIBannerViewCell
        
        if let url = URL(string: (urls?[indexPath.row]) ?? "") {
            print("======start====")
            cell.imageView?.kf.setImage(with: url, placeholder: nil, options: [.forceRefresh], progressBlock: { receivedSize, totalSize in
                print("\(indexPath.row + 1):\(receivedSize)/\(totalSize)")
            }, completionHandler: nil)
        }
        
        return cell
    }
}
