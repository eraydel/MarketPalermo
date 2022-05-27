//
//  FoodTableViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 23/05/22.
//

import UIKit


class FoodTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        print("actualizando los datos...")
        DataManager.instance.getFoodItems()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.instance.food.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        let item = DataManager.instance.food[indexPath.row]
        let imagePlaceHolder = UIImage.init(named: "foodPlaceholder")!
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.owner
        cell.imageView?.contentMode = UIView.ContentMode.scaleToFill
        cell.imageView?.frame.size.width = 60
        cell.imageView?.frame.size.height = 60
        cell.imageView?.layer.cornerRadius = 30
        cell.imageView?.clipsToBounds = true
        cell.imageView?.imageFromURL(urlString:  item.image, PlaceHolderImage: imagePlaceHolder.resizeImageWithHeight(newW: 60, newH: 60)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "foodItemDetail", sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
            case "foodItemDetail":
                let detailsVC = segue.destination as! FoodDetailViewController
                if let indexPath = tableView.indexPathForSelectedRow {
                    let item = DataManager.instance.food[indexPath.row]
                    detailsVC.food = item
                    tableView.deselectRow(at: indexPath, animated: true)
                }

            default:
                print("reloading data...")//self.tableView.reloadData()
        }
    }
    

}

extension UIImage{
    func resizeImageWithHeight(newW: CGFloat, newH: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: newW, height: newH))
        self.draw(in: CGRect(x: 0, y: 0, width: newW, height: newH))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIImageView {

 public func imageFromURL(urlString: String, PlaceHolderImage:UIImage) {

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
                self.image = image?.resizeImageWithHeight(newW: 60, newH: 60)
            })

        }).resume()

    }}
