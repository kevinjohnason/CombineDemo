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
    
    var storedOperationStreams: [OperationStreamModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "storedOperationStreams") else {
                return self.appendDefaultOperationStreamsIfNeeded(streams: [])
            }
            guard let streams = try? JSONDecoder().decode([OperationStreamModel].self, from: data) else {
                return self.appendDefaultOperationStreamsIfNeeded(streams: [])
            }
            return self.appendDefaultOperationStreamsIfNeeded(streams: streams)
        } set {
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedOperationStreams")
            storedOperationStreamUpdated.send(newValue)
        }
    }
    
    var storedGroupOperationStreams: [GroupOperationStreamModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "storedGroupOperationStreams") else {
                return self.appendDefaultGroupOperationStreamsIfNeeded(streams: [])
            }
            guard let streams = try? JSONDecoder().decode([GroupOperationStreamModel].self, from: data) else {
                return self.appendDefaultGroupOperationStreamsIfNeeded(streams: [])
            }
            return self.appendDefaultGroupOperationStreamsIfNeeded(streams: streams)
        } set {
            UserDefaults.standard.set(try! JSONEncoder().encode(newValue), forKey: "storedGroupOperationStreams")
            storedGroupOperationStreamUpdated.send(newValue)
        }
    }
    
    
    let storedStreamUpdated: PassthroughSubject<[StreamModel<String>], Never> = PassthroughSubject()
    
    let storedOperationStreamUpdated: PassthroughSubject<[OperationStreamModel], Never> = PassthroughSubject()
    
    let storedGroupOperationStreamUpdated: PassthroughSubject<[GroupOperationStreamModel], Never> = PassthroughSubject()
    
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
                                        description: nil, stream: streamA, isDefault: true)
        
        let streamB = ["A", "B", "C", "D"].map { StreamItem(value: $0, operatorItem: OperatorItem(type: .delay, value: 1, next: nil)) }
        let serialStreamB = StreamModel(id: UUID(), name: "Serial Stream B",
                                        description: nil, stream: streamB, isDefault: true)
        
        var newStreams = streams
        newStreams.append(serialStreamA)
        newStreams.append(serialStreamB)
        self.storedStreams = newStreams
        return newStreams
    }
    
    func appendDefaultOperationStreamsIfNeeded(streams: [OperationStreamModel]) -> [OperationStreamModel] {
        guard streams.count == 0 else {
            return streams
        }
        guard let sourceStream = storedStreams.first(where: { $0.isDefault }) else {
            return streams
        }
        
        let filterStreamModel = OperationStreamModel(id: UUID(),
                                                     name: "Filter Stream", description: "filter { $0 != 3 )",
                                                     streamModelId: sourceStream.id,
                                                     operatorItem: OperatorItem(type: .filter, value: 3, expression: "%d != %d", next: nil))
        
        
        let dropStreamModel = OperationStreamModel(id: UUID(), name: "Drop Stream", description: "dropFirst(2)",
                                                   streamModelId: sourceStream.id, operatorItem: OperatorItem(type: .drop, value: 2, expression: nil, next: nil))
        
        
        let mapStreamModel = OperationStreamModel(id: UUID(), name: "Map Stream", description: "map { $0 * 2 }",
                                                  streamModelId: sourceStream.id, operatorItem: OperatorItem(type: .map, value: 2, expression: "%d * %d", next: nil))
        
        let scanStreamModel = OperationStreamModel(id: UUID(), name: "Scan Stream", description: "scan(0) { $0 + $1 }",
                                                       streamModelId: sourceStream.id, operatorItem: OperatorItem(type: .scan, value: nil, expression: "%d + %d", next: nil))
        
        var newStreams = streams
        newStreams.append(filterStreamModel)
        newStreams.append(dropStreamModel)
        newStreams.append(mapStreamModel)
        newStreams.append(scanStreamModel)
        return newStreams
    }
    
    func appendDefaultGroupOperationStreamsIfNeeded(streams: [GroupOperationStreamModel]) -> [GroupOperationStreamModel] {
        guard streams.count == 0 else {
            return streams
        }
        guard let sourceStream1 = storedStreams.first(where: { $0.isDefault }) else {
            return streams
        }
        
        guard let sourceStream2 = storedStreams.last(where: { $0.isDefault }) else {
            return streams
        }
        
        let mergeStreamModel = GroupOperationStreamModel(id: UUID(), name: "Merge Stream", description: "Publishers.merge(A, B)", streamModelIds: [sourceStream1.id, sourceStream2.id], operatorItem: OperatorItem(type: .map, value: nil, expression: nil, next: nil))
                        
        return [mergeStreamModel]
    }
    
    func resetStoredStream() {
        storedStreams = appendDefaultStreamsIfNeeded(streams: [])
        storedOperationStreams = appendDefaultOperationStreamsIfNeeded(streams: [])
    }
    
}
