//
//  UserMenu.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 02/06/22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class UserMenu: NSObject {
    
    // singletton pattern
    static let instance = UserMenu()
    
    // var options
    var options = UIStackView(arrangedSubviews: [])
    
    override private init() {
        super.init()
        getOptions()
    }
    
    func getOptions(){
        let spacer = UIView()
        // **** user email
        let useremail = UILabel()
        useremail.text = Auth.auth().currentUser?.email
        useremail.textAlignment = .center
        useremail.font = .boldSystemFont(ofSize: 18)
        useremail.textColor = .white
        
        // **** user image profile
        let userImageProfile = getUserImageprofile()
        
        // **** Close session
        let btnLogout = UIButton()
        btnLogout.setTitle("Cerrar sesión", for: .normal)
        btnLogout.setTitleColor(.blue, for: .application)
        btnLogout.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btnLogout.setImage(UIImage(systemName: "power.circle.fill"), for: .normal)
        btnLogout.tintColor = .white
        btnLogout.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        // **** credits
        let credits = UILabel()
        credits.text = "Created by Erick Ayala | eraydel 2022"
        credits.textAlignment = .center
        credits.font = .boldSystemFont(ofSize: 12)
        credits.textColor = .lightGray
        
        self.options = UIStackView(arrangedSubviews: [userImageProfile , useremail, btnLogout, credits, spacer])
        self.options.axis = .vertical
        self.options.spacing = 12.0
    }
    
    // Get user image profile
    func getUserImageprofile() -> UIImageView {
        let imageProfile = UIImageView()
        let userdefaults = UserDefaults.standard
        
        if let savedValue = userdefaults.url(forKey: "userPictureProfile"){

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: savedValue)
                DispatchQueue.main.async {
                    imageProfile.contentMode = .top
                    imageProfile.image = UIImage(data: data!)
                }
            }
        } else {
            print("ninguna variable almacenada")
        }
        
        return imageProfile
    }
    
    // logout
    @objc func logout(){
        print("cerrando sesión...")
        do {
            try Auth.auth().signOut()
            //Obtenemos una referencia al SceneDelegate:
            //Podría haber mas de una escena en IpAd OS o en MacOS
            let escena = UIApplication.shared.connectedScenes.first
            print("sesión cerrada")
            let sd = escena?.delegate as! SceneDelegate
            sd.cambiarVistaA("")
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
