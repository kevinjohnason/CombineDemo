//
//  DataService.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/28/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import Combine
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
                return self.appendDefaultStreamsIfNeeded(streams: [])
            }
            guard let streams = try? JSONDecoder().decode([StreamModel<String>].self, from: data) else {
                return self.appendDefaultStreamsIfNeeded(streams: [])
            }
            return self.appendDefaultStreamsIfNeeded(streams: streams)
        } set {
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedStreams")
            storedStreamUpdated.send(newValue)
        }
    }
    
    let storedStreamUpdated: PassthroughSubject<[StreamModel<String>], Never> = PassthroughSubject()
    
    func loadStream(id: UUID) -> StreamModel<String> {
        guard let stream = DataService.shared.storedStreams.first(where: {
            $0.id == id
        }) else {
            return StreamModel<String>.new()
        }
        return stream
    }
    
    func appendDefaultStreamsIfNeeded(streams: [StreamModel<String>]) -> [StreamModel<String>] {
        guard (streams.filter { $0.isDefault }).count == 0 else {
            return streams
        }
                                        
        let streamA = (1...4).map { StreamItem(value: String($0), operatorItem: OperatorItem(type: .delay, value: 1, next: nil)) }
        let serialStreamA = StreamModel(id: UUID(), name: "Serial Stream A",
                                       description: "Sequence(1, 2, 3, 4)", stream: streamA, isDefault: true)
        
        let streamB = ["A", "B", "C", "D"].map { StreamItem(value: $0, operatorItem: OperatorItem(type: .delay, value: 1, next: nil)) }
        let serialStreamB = StreamModel(id: UUID(), name: "Serial Stream B",
                                       description: "Sequence(A, B, C, D)", stream: streamB, isDefault: true)
        
        var filterStreamModel = StreamModel(id: UUID(), name: "Filter", description: "filter { $0 != 3 )",
                                            stream: streamA, isDefault: false)
                        
        filterStreamModel.operatorItem = OperatorItem(type: .filter, value: 3, expression: "%d != %d", next: nil)
        
        var newStreams = streams
        newStreams.append(serialStreamA)
        newStreams.append(serialStreamB)
        newStreams.append(filterStreamModel)
        self.storedStreams = newStreams
        return newStreams
    }

}
