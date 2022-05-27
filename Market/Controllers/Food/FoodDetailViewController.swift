//
//  FoodDetailViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 24/05/22.
//

import UIKit

class FoodDetailViewController: UIViewController , UITableViewDataSource , UITableViewDelegate  {
   
    var food: Food!

    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemOwner: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemSchedule: UILabel!
   
    @IBOutlet weak var tableView: UITableView!
    
    
    let imagePlaceHolder = UIImage.init(named: "foodPlaceholder")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            vc.modalPresentationStyle = .overCurrentContext
            vc.titleLabel.text = item.title + " $" + String(item.price)
            vc.notesLabel.text = item.description
            vc.cartButton.setTitle("Contacta al vendedor", for: .normal)
            vc.cartButton.addTarget(self, action: #selector(navigateToWhatsApp), for: .touchUpInside)
            // Keep animated value as false
            // Custom Modal presentation animation will be handled in VC itself
            self.present(vc, animated: false)
        //self.performSegue(withIdentifier: "menuDetails", sender: self)
    }
    
    @objc func navigateToWhatsApp() {
        setMessage(food.owner, "Por favor, le encargo mi pedido, no me vaya adejar sin comer xD...")
    }
    
    func setMessage(_ title:String , _ message:String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Enviar", style: UIAlertAction.Style.destructive, handler: nil))
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
}

