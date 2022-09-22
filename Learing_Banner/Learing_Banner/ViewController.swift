//
//  ViewController.swift
//  Learing_Banner
//
//  Created by JustinChou on 2022/9/22.
//

import UIKit

class ViewController: UIViewController {
    
    var bannerView: AIIBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    func setupUI() {
        bannerView = AIIBannerView(frame: CGRect(x: 0, y: 60, width: view.bounds.width, height: 300))
        let urls = [
            "https://cdn-1.blushmark.com/blushmark/upimg/d8/bd/3269b7e78582be3d7d17c194cc32fe8b4d48d8bd.jpg",
            "https://cdn-1.blushmark.com/blushmark/upimg/bd/f8/8c836e32bced64eef2a8d916d50081a38819bdf8.jpg"
        ]
        
        bannerView?.setData(urls)
        view.addSubview(bannerView!)
    }
    
}

