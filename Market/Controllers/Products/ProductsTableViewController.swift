//
//  ProductsTableViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 03/06/22.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    var searchedProducts = [Products]()
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        //init search controller
        initSearchController()
        setGradientBackground()
        addLeftBarIcon(named: "logo-horizontal")
        
    }
    
    func initSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.searchTextField.placeholder = "¿Qué producto estás buscando?"
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["Todo","Ropa","Calzado","Diversos"]
        searchController.searchBar.delegate = self
        
    }
    
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        print("actualizando los datos...")
        DataManager.instance.getProductstems()
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
        if searchController.isActive {
            return searchedProducts.count
        }
        else {
            return DataManager.instance.products.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productsCell", for: indexPath)
        
        if searchController.isActive {
            let item = searchedProducts[indexPath.row]
            let imagePlaceHolder = UIImage.init(named: "productPlaceholder")!
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.owner
            cell.imageView?.contentMode = UIView.ContentMode.scaleToFill
            cell.imageView?.frame.size.width = 60
            cell.imageView?.frame.size.height = 60
            cell.imageView?.layer.cornerRadius = 30
            cell.imageView?.clipsToBounds = true
            cell.imageView?.imageFromURL(urlString:  item.image, PlaceHolderImage: imagePlaceHolder.resizeImageWithHeight(newW: 60, newH: 60)!)
        }
        else {
            let item = DataManager.instance.products[indexPath.row]
            let imagePlaceHolder = UIImage.init(named: "productPlaceholder")!
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.owner
            cell.imageView?.contentMode = UIView.ContentMode.scaleToFill
            cell.imageView?.frame.size.width = 60
            cell.imageView?.frame.size.height = 60
            cell.imageView?.layer.cornerRadius = 30
            cell.imageView?.clipsToBounds = true
            cell.imageView?.imageFromURL(urlString:  item.image, PlaceHolderImage: imagePlaceHolder.resizeImageWithHeight(newW: 60, newH: 60)!)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive {
            let selectedProduct = searchedProducts[indexPath.row]
            print(selectedProduct)
        }
        else {
            let selectedProduct = DataManager.instance.products[indexPath.row]
            print(selectedProduct)
        }
        
        self.performSegue(withIdentifier: "productItemDetail", sender: self)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
            case "productItemDetail":
                let detailsVC = segue.destination as! ProductDetailViewController
                if let indexPath = tableView.indexPathForSelectedRow {
                    if searchController.isActive {
                        let item = searchedProducts[indexPath.row]
                        detailsVC.product = item
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                    else {
                        let item = DataManager.instance.products[indexPath.row]
                        detailsVC.product = item
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                }

            default:
                print("reloading data...")
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
        print("user click on menu ")
        let vc = CustomModalViewController()
        vc.defaultHeight = 250
        vc.modalPresentationStyle = .overFullScreen
        vc.containerView.backgroundColor = .black
        vc.contentStackView = UserMenu.instance.options
        self.present(vc, animated: false)
    }
    
    //MARK: -
    private func setGradientBackground() {
        let colorTop =  UIColor(red: 140/255, green: 143/255, blue: 160/255, alpha: 0.7).cgColor
        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.15]
        gradientLayer.frame = self.view.bounds

        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: .zero)
        tableView.backgroundView = backgroundView
    }
    
    func addLeftBarIcon(named:String) {

        let logoImage = UIImage.init(named: named)
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:100,height:25.0)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 100)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 25)
         heightConstraint.isActive = true
         widthConstraint.isActive = true
         navigationItem.leftBarButtonItem =  imageItem
    }
    

}


// MARK: - Extension for searchBar
extension ProductsTableViewController: UISearchBarDelegate , UISearchResultsUpdating  {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        filterForSearchTextAndScopeButton(searchText: searchText , scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String , scopeButton: String = "Todo"){
        
        self.searchedProducts = DataManager.instance.products.filter
        {
            item in
            let scopeMatch = (scopeButton == "Todo" || item.category == scopeButton )
            if searchController.searchBar.text != ""
            {
                let searchTextMatch = item.title.lowercased().contains(searchText.lowercased())
                return scopeMatch && searchTextMatch
            }
            else
            {
                return scopeMatch
            }
        }
        
        tableView.reloadData()
    }
}
