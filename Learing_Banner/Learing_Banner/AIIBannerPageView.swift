//
//  AIIBannerPageView.swift
//  Learing_Banner
//
//  Created by JustinChou on 2022/9/23.
//

import Foundation
import UIKit
import Kingfisher

protocol BannerPageControlDelegate: NSObjectProtocol {
    func didPageChanged(index: Int)
}

let kAIIBannerViewCellIdentifier = "kAIIBannerViewCellIdentifier"

class AIIBannerPageView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate var timer: Timer?
    
    // 利用委托实现图片指示器
    var bannerPageViewDelegate: BannerPageControlDelegate?
    
    // 是否设置为无限循环播放
    fileprivate var loop: Bool = true
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
        
        self.loop = loop
    }
    
    func setUrls(_ urls: [String]) {
        self.urls = urls
        
        aii_reloadData()
        
        startTimer()
    }
    
    func setLoop(_ loop: Bool) {
        self.loop = loop
    }
    
    func aii_reloadData() {
        if loop {
            // 对原始数据进行修改 在第一张图片之前插入原数组中最后一张图片，在最后一张图片之后插入原数组中第一章图片
            urls!.insert(urls!.last!, at: 0)
            urls!.append(urls![1])
        }
        
        reloadData()
        layoutIfNeeded()
        
        if loop {
            // 由于数组被修改后，第一张被展示的图片的下标应该是1
            scrollToItem(at: IndexPath(row: loop ? 1 : 0, section: 0), at: UICollectionView.ScrollPosition(rawValue: 0), animated: false)
        }
    }
}

// 定时器
extension AIIBannerPageView {
    private func startTimer() {
        endTimer()
        print("Timer Start!!!!")
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] _ in
            self?.nextPage()
        })
    }
    
    private func nextPage() {
        let index = Int(
            (contentOffset.x / frame.size.width)
                .rounded(.toNearestOrAwayFromZero)
            )
        scrollToItem(at: IndexPath(row: index + 1, section: 0),
                     at: UICollectionView.ScrollPosition(rawValue: 0),
                     animated: true)
    }
    
    private func endTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// 无限轮播要实现的委托方法
extension AIIBannerPageView {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = Int(
            (contentOffset.x / frame.size.width)
                .rounded(.toNearestOrAwayFromZero)
        )
        
        if loop {
            // 以 [c, a, b, c, a] 为例子进行判断
            if index == 0 {
                // 为0表示已经滑到数组的最左侧的图片，即c，此时应该让轮播器显示另一个相同的图片c
                scrollToItem(at: IndexPath(row: urls!.count - 2, section: 0), at: UICollectionView.ScrollPosition(rawValue: 0), animated: false)
                index = urls!.count - 3
            } else if index == urls!.count - 1 {
                // 为最后表示已经滑到数组的最右侧的图片，即a，此时应该让轮播器显示另一个相同的图片a
                scrollToItem(at: IndexPath(row: 1, section: 0), at: UICollectionView.ScrollPosition(rawValue: 0), animated: false)
                index = 0
            } else {
                index -= 1
            }
        }
        
        bannerPageViewDelegate?.didPageChanged(index: index)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 通过偏移量计算图片的下标
        let index = Int(contentOffset.x / frame.size.width)
        
        if loop {
            // 以 [c, a, b, c, a] 为例子进行判断
            if index == 0 {
                // 为0表示已经滑到数组的最左侧的图片，即c，此时应该让轮播器显示另一个相同的图片c
                scrollToItem(at: IndexPath(row: urls!.count - 2, section: 0), at: UICollectionView.ScrollPosition(rawValue: 0), animated: false)
            } else if index == urls!.count - 1 {
                // 为最后表示已经滑到数组的最右侧的图片，即a，此时应该让轮播器显示另一个相同的图片a
                scrollToItem(at: IndexPath(row: 1, section: 0), at: UICollectionView.ScrollPosition(rawValue: 0), animated: false)
            }
        }
    }
}

// 数据源的方法
extension AIIBannerPageView {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numOfItems = urls?.count ?? 0
        return numOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAIIBannerViewCellIdentifier, for: indexPath) as! AIIBannerViewCell
        
        if let url = URL(string: (urls?[indexPath.row]) ?? "") {
            // 加载用菊花
            cell.imageView?.kf.indicatorType = .activity
            // KingFisher 实现加载网络图片
            cell.imageView?.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: { receivedSize, totalSize in
                print("下载进度：\(indexPath.row + 1):\(receivedSize)/\(totalSize)")
            }, completionHandler: nil)
        }
        
        return cell
    }
}
