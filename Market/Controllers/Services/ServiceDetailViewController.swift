//
//  ServiceDetailViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 07/06/22.
//

import UIKit
import MapKit

class ServiceDetailViewController: UIViewController {
    
    var service: Services!
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemOwner: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemSchedule: UILabel!
    @IBOutlet weak var itemResume: UITextView!
    @IBOutlet weak var itemExperience: UITextView!
    let imagePlaceHolder = UIImage.init(named: "servicePlaceholder")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = service.title
        setGradientBackground()
        itemImage.contentMode = UIView.ContentMode.scaleAspectFill
        itemImage.frame.size.width = UIScreen.main.bounds.width - 16
        itemImage.layer.cornerRadius = 5
        itemImage.clipsToBounds = true
        itemImage.mainImage(urlString:  service.image, PlaceHolderImage: imagePlaceHolder)
        itemOwner.text = service.owner
        itemDescription.text = service.description
        itemSchedule.text = service.schedule
        itemResume.text = service.resume
        itemExperience.text = service.experience
    }
    
    @IBAction func showContact(_ sender: Any) {
        print("mostrando información del proveedor del servicio")
        let vc = CustomModalViewController()
        vc.defaultHeight = 450
        vc.modalPresentationStyle = .overFullScreen
        BusinessOwner.instance.ownerName = service.owner
        BusinessOwner.instance.ownerPhoneNumber = service.telephone
        BusinessOwner.instance.ownerLocation = CLLocationCoordinate2D(latitude: service.location.first!.lat, longitude: service.location.first!.lng)
        BusinessOwner.instance.ownerAddress = service.address
        BusinessOwner.instance.getOptions()
        vc.contentStackView = BusinessOwner.instance.options
        self.present(vc, animated: false)
    }
    
    @IBAction func contact(_ sender: Any) {
        var fullMob = "+52"+service.telephone
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        let urlWhats = "whatsapp://send?phone=\(fullMob)&text=Hola, estoy interesado en contratar sus servicios como " + service.title
        
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
    
    //MARK: - Gradient
    @IBAction func btnShare(_ sender: Any) {
        print("sharing a content..")
        let image:UIImage = itemImage.image!
        let objetosParaCompartir:[Any] = [ image, service.owner , service.telephone ]
        let ac = UIActivityViewController(activityItems:objetosParaCompartir, applicationActivities: nil)
        self.present(ac, animated: true)
    }
    private func setGradientBackground() {
        let colorTop =  UIColor(red: 140/255, green: 143/255, blue: 160/255, alpha: 0.7).cgColor
        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.15]
        gradientLayer.frame = self.view.bounds

        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: .zero)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
}
