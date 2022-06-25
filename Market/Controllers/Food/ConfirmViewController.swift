//
//  ConfirmViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 31/05/22.
//

import UIKit
import Lottie

class ConfirmViewController: UIViewController {
    
    var animation: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.animation = .init(name: "food-order")
        self.animation?.frame.size = CGSize(width: 400, height: 400)
        self.animation?.center = self.view.center
        self.animation?.loopMode = .loop
        self.animation?.play()
        self.view.addSubview(self.animation!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
