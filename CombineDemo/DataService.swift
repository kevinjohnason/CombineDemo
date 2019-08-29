//
//  DataService.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/28/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation

class DataService {
    static let shared = DataService()    
    var currentStream: StreamModel<String>
        {
        get {
            guard let data = UserDefaults.standard.data(forKey: "currentStream") else {
                return StreamModel<String>(name: "default stream", stream: [])
            }
            return try! JSONDecoder().decode(StreamModel<String>.self, from: data)
        } set {
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "currentStream")
        }
    }

}


struct StreamModel<T: Codable>: Codable {
    let name: String
    let stream: [StreamItem<T>]
}

struct StreamItem<T: Codable>: Codable {
    let value: T
    var delay: Double? = nil
}
