//
//  HomeViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 21/05/22.
//

import UIKit
import FirebaseAuth
import SwiftUI
import GoogleSignIn
import Lottie

class HomeViewController: UIViewController {
    
    var animation: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserMenu.instance.getOptions()
        setGradientBackground()
        showAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAnimation()
    }
    
    func showAnimation(){
        self.animation?.removeFromSuperview()
        self.animation = .init(name: "welcome-market")
        self.animation?.frame.size = CGSize(width: 330, height: 300)
        self.animation?.center = self.view.center
        self.animation?.loopMode = .loop
        self.animation?.play()
        self.view.addSubview(self.animation!)
    }
    

    @IBAction func btnLogout(_ sender: Any) {
        print("cerrando sesión...")
        let vc = CustomModalViewController()
        vc.defaultHeight = 250
        vc.modalPresentationStyle = .overFullScreen
        vc.containerView.backgroundColor = .black
        vc.contentStackView = UserMenu.instance.options // singleton pattern
        self.present(vc, animated: false)
    }
    
    //MARK: - Gradient
    private func setGradientBackground() {
        let colorTop =  UIColor(red: 140/255, green: 143/255, blue: 160/255, alpha: 0.7).cgColor
        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.005, 0.15]
        gradientLayer.frame = self.view.bounds

        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: .zero)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
