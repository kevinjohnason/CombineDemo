//
//  SingleStreamViewModel.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/1/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class SingleStreamViewModel: ObservableObject {
        
    let objectWillChange: AnyPublisher<Void, Never>
    let objectWillChangeSubject = PassthroughSubject<Void, Never>()
    let publisher: AnyPublisher<String, Error>
    let animationSeconds: Double = 1.5
    var percent: CGFloat = 0
    var text: String = ""
    
    var cancellable: Cancellable? = nil
    
    init(publisher: AnyPublisher<String, Error>) {
        objectWillChange = objectWillChangeSubject.eraseToAnyPublisher()
        self.publisher = publisher
    }
    
    func subscribe() {
        self.cancellable = publisher.sink(receiveCompletion: { (_) in
                                       }) { (value) in
                                        self.display(text: value)
                                   }
    }
    
    private var pendingValues: [String] = []
    
            
    private func display(text: String, checkPending: Bool = true) {
        if checkPending {
            pendingValues.append(text)
            if pendingValues.count > 1 {
                return
            }
        }
        self.text = text
        self.percent = 0
        self.objectWillChangeSubject.send(())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.percent = 1
            self.objectWillChangeSubject.send(())            
            if self.pendingValues.count > 0 {
                self.pendingValues.remove(at: 0)
                if self.pendingValues.count > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.animationSeconds + 0.1) {
                        self.display(text: self.pendingValues[0], checkPending: false)
                    }
                }
            }
        }
    }
    
    
    func cancel() {
        self.cancellable?.cancel()
        self.percent = 0
        self.objectWillChangeSubject.send(())
        self.pendingValues.removeAll()
    }
    
    
}
