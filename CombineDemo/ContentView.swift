//
//  ContentView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct ContentView: View {
        
    let publisher = CombineService.shared.commonPublisher
    
    var body: some View {
        NavigationView {
            List {                
                NavigationLink(destination: SingleStreamView(viewModel: SingleStreamViewModel(title: "Just(\"A\")", publisher: Just("A").eraseToAnyPublisher())).navigationBarTitle("Single Value")) {
                           MenuRow(detailViewName: "Single Value")
                    }
                NavigationLink(destination: SingleStreamView(viewModel: SingleStreamViewModel(title: "Publishers.Sequence([\"1\", \"2\", \"3\", \"4\")", publisher: publisher)).navigationBarTitle("Serial Stream")) {
                    MenuRow(detailViewName: "Serial Stream")
                }
                NavigationLink(destination: DoubleStreamView(title1: "A: Publishers.Sequence([1, 2, 3, 4])", title2: "A.map { $0 * 10 }", publisher: publisher, convertingPublisher: { (publisher) -> AnyPublisher<String, Never> in
                    publisher.map { Int($0)! }.map { String($0 * 2) }.eraseToAnyPublisher()
                })) {
                    MenuRow(detailViewName: "Map Stream")
                }
                NavigationLink(destination: OperationStreamView(title: "Publishers.Merge(A, B)") { (numberPublisher, letterPublisher) -> AnyPublisher<String, Never> in
                    Publishers.Merge(numberPublisher, letterPublisher).eraseToAnyPublisher()
                }.navigationBarTitle("Merge")) {
                    MenuRow(detailViewName: "Merge Stream")
                }
                NavigationLink(destination: OperationStreamView(title: "A.flatMap { _ in B } ") { (numberPublisher, letterPublisher) -> AnyPublisher<String, Never> in
                    numberPublisher.flatMap { _ in letterPublisher }.eraseToAnyPublisher()
                }.navigationBarTitle("FlatMap")) {
                    MenuRow(detailViewName: "FlatMap Stream")
                }
                NavigationLink(destination: OperationStreamView(title: "A.append(B) ") { (numberPublisher, letterPublisher) -> AnyPublisher<String, Never> in
                    numberPublisher.append(letterPublisher).eraseToAnyPublisher()
                }.navigationBarTitle("Append")) {
                    MenuRow(detailViewName: "Append Stream")
                }                
                NavigationLink(destination: combineResultStreamView().navigationBarTitle("Zip")) {
                    MenuRow(detailViewName: "Combine Stream")
                }
            }.navigationBarTitle(Text("Combine Demo"))
        }
        
    }
    
    func combinSingleStreamView() -> CombineSingleStreamView {
        let combineLatestPublisher = Publishers.Zip(publisher, CombineService.shared.serialLetterPublisher()).eraseToAnyPublisher()
        return CombineSingleStreamView(viewModel:
            CombineSingleStreamViewModel(title: "Zip", publisher: combineLatestPublisher))
                
    }
    
    func combineResultStreamView() -> CombineResultStreamView {
        CombineResultStreamView(title: "Zip") { (numberPublisher, letterPublisher) -> AnyPublisher<(String, String), Never> in
            Publishers.Zip(numberPublisher, letterPublisher).eraseToAnyPublisher()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()//.previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
#endif
