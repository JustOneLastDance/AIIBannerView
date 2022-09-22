//
//  AIIBannerView.swift
//  Learing_Banner
//
//  Created by JustinChou on 2022/9/23.
//

// 封装 BannerView

import Foundation
import UIKit

class AIIBannerView: UIView {
    var bannerPageView: AIIBannerPageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bannerPageView = AIIBannerPageView(frame: frame, loop: true)
        addSubview(bannerPageView!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AIIBannerView {
    
    func setData(_ urls: [String]) {
        bannerPageView?.setUrls(urls)
    }
}
