//
//  ContactViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 04/06/22.
//

import UIKit
import Messages
import MessageUI
import MapKit

class BusinessOwner: NSObject, MKMapViewDelegate {

    // singletton pattern
    static let instance = BusinessOwner()
    
    // var options
    var options = UIStackView(arrangedSubviews: [])
    var ownerName = ""
    var ownerPhoneNumber = ""
    var ownerAddress = ""
    var ownerLocation = CLLocationCoordinate2D()
    
    override private init() {
        super.init()
        getOptions()
    }
    
    func getOptions() {
        let spacer = UIView()
        // **** title
        let title = UILabel()
        title.text = self.ownerName
        title.textAlignment = .center
        title.font = .boldSystemFont(ofSize: 18)
        title.textColor = .black
        
        // **** label name
        let labelName = UILabel()
        labelName.text = self.ownerPhoneNumber
        labelName.textAlignment = .center
        labelName.font = .systemFont(ofSize: 16)
        labelName.textColor = .darkGray

        
        // **** phone
        let btnCall = UIButton()
        btnCall.setImage(UIImage(systemName: "phone")?.resizeImageWithHeight(newW: 32, newH: 32), for: .normal)
        btnCall.setTitle("Llamada", for: .normal)
        btnCall.setTitleColor(.blue, for: .normal)
        btnCall.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnCall.addTarget(self, action: #selector(contactCall), for: .touchUpInside)
        
        // **** whatsapp
        let btnWhatsApp = UIButton()
        btnWhatsApp.setImage(UIImage(named: "ic_whatsapp")?.resizeImageWithHeight(newW: 32, newH: 32), for: .normal)
        btnWhatsApp.setTitle("Mensaje", for: .normal)
        btnWhatsApp.setTitleColor(.blue, for: .normal)
        btnWhatsApp.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnWhatsApp.addTarget(self, action: #selector(contactWhatsApp), for: .touchUpInside)

        
        let sv = UIStackView(arrangedSubviews: [btnWhatsApp,labelName,btnCall])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalCentering
        sv.spacing = 4
        
        let elMapa = MKMapView()
        elMapa.mapType = .standard
        elMapa.delegate = self
        let miUbicacion = self.ownerLocation
        elMapa.setRegion(MKCoordinateRegion(center: miUbicacion, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        
        //Colocando un pin
        let elPin = MKPointAnnotation()
        elPin.coordinate = miUbicacion
        elPin.title = self.ownerName + " " + self.ownerAddress
        elMapa.addAnnotation(elPin)
        
        self.options = UIStackView(arrangedSubviews: [title, sv, elMapa, spacer])
        self.options.axis = .vertical
        self.options.spacing = 12
    }
    
    
    
   
    
    @objc func contactWhatsApp(){
        var fullMob = "+52"+self.ownerPhoneNumber
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        let urlWhats = "whatsapp://send?phone=\(fullMob)&text=Hola, buen día."
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                        if Bool {
                            print("action executed succsessfully")
                        }
                        else {
                            print(Bool)
                        }
                        
                    })
                } else {
                    print("WhatsApp Not Found on your device")
                }
            }
        }
    }
    
    @objc func contactCall(){

        guard let url = URL(string: "tel://\(self.ownerPhoneNumber)") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
           
            UIApplication.shared.open(url)
        } else {
            print("No fue posible realizar la acción solicitada")
        }
    }

}
