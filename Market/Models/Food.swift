//
//  Food.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 23/05/22.
//

import Foundation

struct Food: Codable {
    
    let id: Int
    let title: String
    let description: String
    let image: String
    let category: String
    let owner: String
    let schedule: String
    let address: String
    let telephone: String
    let location: [Location]
    let menu: [Menu]     
}

struct Menu: Codable {
    
    let id: Int
    let title: String
    let description: String
    let price: Int
    let image: String
    
}
