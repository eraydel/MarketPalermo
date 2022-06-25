//
//  FoodDetailViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 24/05/22.
//

import UIKit
import MapKit

class FoodDetailViewController: UIViewController , UITableViewDataSource , UITableViewDelegate  {
   
    var food: Food!

    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemOwner: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemSchedule: UILabel!
   
    @IBOutlet weak var tableView: UITableView!
    
    
    let imagePlaceHolder = UIImage.init(named: "foodPlaceholder")!
    var t: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        self.title = food.title
        itemImage.contentMode = UIView.ContentMode.scaleAspectFill
        itemImage.frame.size.width = UIScreen.main.bounds.width - 16
        itemImage.layer.cornerRadius = 5
        itemImage.clipsToBounds = true
        itemImage.mainImage(urlString:  food.image, PlaceHolderImage: imagePlaceHolder)
        itemOwner.text = food.owner
        itemDescription.text = food.description
        itemSchedule.text = food.schedule
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return food.menu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuDetails", for: indexPath)
        let item = food.menu[indexPath.row]
        self.t = item.title + " $" + String(item.price) + " " + item.description
        cell.textLabel?.text = item.title + " $" + String(item.price)
        cell.detailTextLabel?.text = item.description
        let imagePlaceHolder = UIImage.init(named: "foodPlaceholder")!
        cell.imageView?.contentMode = UIView.ContentMode.scaleToFill
        cell.imageView?.frame.size.width = 60
        cell.imageView?.frame.size.height = 60
        cell.imageView?.layer.cornerRadius = 30
        cell.imageView?.clipsToBounds = true
        cell.imageView?.imageFromURL(urlString:  item.image, PlaceHolderImage: imagePlaceHolder.resizeImageWithHeight(newW: 60, newH: 60)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = food.menu[indexPath.row]
        
        let vc = CustomModalViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.defaultHeight = 460
            vc.titleLabel.text = item.title + " $" + String(item.price)
            vc.notesLabel.text = item.description
            
            vc.imageDetail.contentMode = UIView.ContentMode.scaleAspectFit
            vc.imageDetail.layer.cornerRadius = 10
            vc.imageDetail.clipsToBounds = true
            vc.imageDetail.detailImageFromURL(urlString:  item.image, PlaceHolderImage: imagePlaceHolder)
            
            vc.cartButton.setTitle("Contacta al vendedor", for: .normal)
            vc.cartButton.addTarget(self, action: #selector(contactWhatsApp), for: .touchUpInside)
            // Keep animated value as false
            // Custom Modal presentation animation will be handled in VC itself
            self.present(vc, animated: false)
        //self.performSegue(withIdentifier: "menuDetails", sender: self)
    }
    
    @objc func contactWhatsApp(){
        var fullMob = "+52"+food.telephone
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        let urlWhats = "whatsapp://send?phone=\(fullMob)&text=Hola, estoy interesado en " + self.t
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                        if Bool {
                            let vc = CustomModalViewController()
                            vc.navigateToWhatsApp()
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
    
    
    
    func setMessage(_ title:String , _ message:String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Enviar", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion:nil)
        //self.performSegue(withIdentifier: "confirmFood", sender: self)
    }
    

    @IBAction func showContact(_ sender: Any) {
        print("mostrando información del vendedor")
        let vc = CustomModalViewController()
        vc.defaultHeight = 450
        vc.modalPresentationStyle = .overFullScreen
        BusinessOwner.instance.ownerName = food.owner
        BusinessOwner.instance.ownerPhoneNumber = food.telephone
        BusinessOwner.instance.ownerLocation = CLLocationCoordinate2D(latitude: food.location.first!.lat, longitude: food.location.first!.lng)
        BusinessOwner.instance.ownerAddress = food.address
        BusinessOwner.instance.getOptions()
        vc.contentStackView = BusinessOwner.instance.options
        self.present(vc, animated: false)
    }
    

    @IBAction func btnShare(_ sender: Any) {
        print("sharing a content..")
        let image:UIImage = itemImage.image!
        let objetosParaCompartir:[Any] = [ image, food.owner , food.telephone ]
        let ac = UIActivityViewController(activityItems:objetosParaCompartir, applicationActivities: nil)
        self.present(ac, animated: true)
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
            case "confirmFood":
                let detailsVC = segue.destination as! ConfirmViewController
            self.present(detailsVC, animated: true, completion: nil )

            default:
                print("reloading data...")//self.tableView.reloadData()
        }
    }
    
    //MARK: - Gradient
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




extension UIImageView {
    
    public func mainImage(urlString: String, PlaceHolderImage:UIImage) {

           if self.image == nil{
                 self.image = PlaceHolderImage
           }

           URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

               if error != nil {
                   print(error ?? "No Error")
                   return
               }
               DispatchQueue.main.async(execute: { () -> Void in
                   let image = UIImage(data: data!)
                   self.image = image
               })

           }).resume()

       }
    
    public func previewImage(urlString: String, PlaceHolderImage:UIImage) {

           if self.image == nil{
                 self.image = PlaceHolderImage
           }

           URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

               if error != nil {
                   print(error ?? "No Error")
                   return
               }
               DispatchQueue.main.async(execute: { () -> Void in
                   let image = UIImage(data: data!)
                   self.image = image?.resizeImageWithHeight(newW: UIScreen.main.bounds.width - 16, newH: 200)
               })

           }).resume()

       }
}

