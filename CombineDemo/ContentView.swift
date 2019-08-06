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
                NavigationLink(destination: SingleStreamView(viewModel: SingleStreamViewModel(title: "", publisher: publisher)).navigationBarTitle("Serial Stream")) {
                    MenuRow(detailViewName: "Serial Stream")
                }
                NavigationLink(destination: OperationStreamView { (numberPublisher, letterPublisher) -> AnyPublisher<String, Never> in
                    Publishers.Merge(numberPublisher, letterPublisher).eraseToAnyPublisher()
                }.navigationBarTitle("Merge")) {
                    MenuRow(detailViewName: "Merge Stream")
                }
                NavigationLink(destination: OperationStreamView { (numberPublisher, letterPublisher) -> AnyPublisher<String, Never> in
                    numberPublisher.flatMap { _ in letterPublisher }.eraseToAnyPublisher()
                }.navigationBarTitle("FlatMap")) {
                    MenuRow(detailViewName: "FlatMap Stream")
                }
            }.navigationBarTitle(Text("Combine Demo"))
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
