//
//  Products.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 03/06/22.
//

import Foundation

struct Products: Codable {
    
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
    let catalog: [Catalog]
}

struct Catalog: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Int
    let image: String
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}
