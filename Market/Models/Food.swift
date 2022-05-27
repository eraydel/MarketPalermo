//
//  Food.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 23/05/22.
//

import Foundation
import SwiftUI

struct Food: Codable {
    
    let id: Int
    let title: String
    let description: String
    let image: String
    let owner: String
    let schedule: String
    let address: String
    let menu: [Menu]
    /*
    let price: Double
    let category: String
    let subcategory: String
    
     */
     
}

struct Menu: Codable {
    
    let id: Int
    let title: String
    let description: String
    let price: Int
    let image: String
    
}
