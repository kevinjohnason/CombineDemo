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
        
    let objectWillChange: AnyPublisher<Int, Never>
    let objectWillChangeSubject = PassthroughSubject<Int, Never>()
    
    var percent: CGFloat = 0

    var text: String = ""

    var cancellable: Cancellable? = nil
    
    init() {
        objectWillChange = objectWillChangeSubject.eraseToAnyPublisher()
    }
    
    func subscribe() {        
        self.cancellable = CombineService.shared.intervalSerialNumberPublisher()
                                       .sink(receiveCompletion: { (_) in
                                       }) { (value) in
                                            self.text = String(value)                                            
                                            self.percent = 0
                                            self.objectWillChangeSubject.send(value)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            self.percent = 1
                                            self.objectWillChangeSubject.send(value)
                                        }
                                   }
    }
    
    func cancel() {
        self.cancellable?.cancel()
        self.percent = 0
        self.objectWillChangeSubject.send(0)
    }
    
    
}
