//
//  HomeViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 21/05/22.
//

import UIKit
import FirebaseAuth
import SwiftUI

class HomeViewController: UIViewController {

    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnLogout(_ sender: Any) {
        //Auth.auth().signOut()
        print("cerrando sesión...")
        let alert = UIAlertController(title: "¿Seguro bro?", message: "Realmente deseas cerrar tu sesión?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        let btnNo = UIAlertAction(title: "Sí", style: .destructive) { action in
            
            do {
                try Auth.auth().signOut()
                //Obtenemos una referencia al SceneDelegate:
                //Podría haber mas de una escena en IpAd OS o en MacOS
                let escena = UIApplication.shared.connectedScenes.first
                let sd = escena?.delegate as! SceneDelegate
                sd.cambiarVistaA("")
            }
            catch {
                
            }
        }
        alert.addAction(btnNo)
        self.present(alert, animated: true, completion: nil)
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
