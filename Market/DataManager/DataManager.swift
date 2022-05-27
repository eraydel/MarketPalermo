//
//  DataManager.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 23/05/22.
//

import Foundation

class DataManager: NSObject {
    
    // singletton pattern
    static let instance = DataManager()
    
    // base url
    let baseUrl = "https://demo7733613.mockable.io"
    // api
    let api = "/api/v1/"
    
    // Food
    var food = [Food]()
    
    override private init() {
        super.init()
    }
    
    // getItemsList
    func getFoodItems(){
        if let url = URL(string: baseUrl + api + "foodItems" ) {
            var request = URLRequest(url: url )
            request.httpMethod = "GET"
            let sesion = URLSession.shared
            let task = sesion.dataTask(with: request) { data, response, error in
                if error != nil {
                    print ("ocurrio un error \(error!.localizedDescription)")
                }
                else {
                    do {
                        self.food = try JSONDecoder().decode([Food].self, from:data!)
                        print (self.food)
                    }
                    catch {
                        print("error al convertir a JSON \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
        else {
            print("error al consultar la ruta")
        }
    }
}
