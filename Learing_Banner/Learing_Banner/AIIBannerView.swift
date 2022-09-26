//
//  AIIBannerView.swift
//  Learing_Banner
//
//  Created by JustinChou on 2022/9/23.
//

// 封装 BannerView

import Foundation
import UIKit

class AIIBannerView: UIView, BannerPageControlDelegate {
    
    var bannerPageView: AIIBannerPageView?
    private var pageControl: UIPageControl?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bannerPageView = AIIBannerPageView(frame: frame, loop: true)
        bannerPageView?.bannerPageViewDelegate = self
        addSubview(bannerPageView!)
        pageControl = UIPageControl(frame: CGRect(x: 0, y: bounds.maxY - 20, width: bounds.width, height: 0))
        pageControl?.pageIndicatorTintColor = UIColor.systemGray5
        pageControl?.currentPageIndicatorTintColor = UIColor.yellow
        addSubview(pageControl!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AIIBannerView {
    
    func didPageChanged(index: Int) {
        pageControl?.currentPage = index
    }
    
    func didClickCell(index: Int) {
        print("BannerView 进行跳转: \(index)")
    }
    
    func setData(_ urls: [String]) {
        pageControl?.numberOfPages = urls.count
        bannerPageView?.setUrls(urls)
    }
}
