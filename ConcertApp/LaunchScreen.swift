////
////  LaunchScreen.swift
////  ConcertApp
////
////  Created by Vitalik on 9/18/19.
////  Copyright © 2019 Misha. All rights reserved.
////
//
//import UIKit
//import RevealingSplashView
//import LBTAComponents
//
//class LaunchScreenViewController: UIViewController {
//    
//    let revealingSplashView = RevealingSplashView(iconImage: UIImage(imageLiteralResourceName: "RevealingSplashViewIcon"), iconInitialSize: CGSize(width: 123, height: 123), backgroundColor: UIColor(r: 78, g: 172, b: 248))
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        revealingSplashView.animationType = .heartBeat
//        
//        view.addSubview(revealingSplashView)
//
//        
//        revealingSplashView.startAnimation()
//        
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
//            self.revealingSplashView.heartAttack = true
//        }
//
//
//    }
//    
//
//
//}
