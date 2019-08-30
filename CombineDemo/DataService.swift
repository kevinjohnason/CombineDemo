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
            let defaullModel = StreamModel<String>(id: UUID(), name: "default stream", description: nil, stream: [])
            guard let data = UserDefaults.standard.data(forKey: "currentStream") else {
                return defaullModel
            }
            guard let model = try? JSONDecoder().decode(StreamModel<String>.self, from: data) else {
                return defaullModel
            }
            return model
        } set {
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "currentStream")
        }
    }
    
    
    var storedStreams: [StreamModel<String>] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "storedStreams") else {
                return []
            }
            guard let streams = try? JSONDecoder().decode([StreamModel<String>].self, from: data) else {
                return []
            }
            return streams
        } set {
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedStreams")
        }
    }
    
    func loadStream(id: UUID) -> StreamModel<String> {
        guard let stream = DataService.shared.storedStreams.first(where: {
            $0.id == id
        }) else {
            return StreamModel(id: UUID(), name: "Default Stream", description: nil, stream: [])
        }
        return stream
    }

}


struct StreamModel<T: Codable>: Codable, Identifiable {
    let id: UUID
    var name: String
    var description: String?
    var stream: [StreamItem<T>]
}

struct StreamItem<T: Codable>: Codable {
    let value: T
    var delay: Double? = nil
}
