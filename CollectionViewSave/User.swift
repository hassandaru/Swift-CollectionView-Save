//
//  User.swift
//  CollectionViewSave
//
//  Created by Hassan Sohail Dar on 5/9/2022.
//

import UIKit

class User: NSObject, Codable {
    var image: String
    var name: String
    
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

class ResponseData: Codable {
    let body: [User]?
}

class ResponseRoot: Codable {
    let data: ResponseData
}
