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
    
    @ObservedObject var viewModel = ContentViewModel()
        
    var body: some View {
        NavigationView {
            
            List {
                StreamListView(storedStreams: $viewModel.storedStreams)
                NavigationLink(destination: filterStreamView()
                    .navigationBarTitle("Filter")) {
                    MenuRow(detailViewName: "Filter Stream")
                }
                NavigationLink(destination: dropFirstStreamView()
                    .navigationBarTitle("Drop")) {
                    MenuRow(detailViewName: "Drop Stream")
                }
                NavigationLink(destination: DoubleStreamView(streamModel: viewModel.streamAModel, operatorTitle: "A.map { $0 * 2 }", publisher: self.viewModel.streamA, convertingPublisher: { (publisher) -> AnyPublisher<String, Never> in
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
                NavigationLink(destination: zipResultStreamView().navigationBarTitle("Zip")) {
                    MenuRow(detailViewName: "Zip Stream")
                }
                NavigationLink(destination: OperationStreamView(title: "A.append(B)") { (numberPublisher, letterPublisher) -> AnyPublisher<String, Never> in
                    numberPublisher.append(letterPublisher).eraseToAnyPublisher()
                }.navigationBarTitle("Append")) {
                    MenuRow(detailViewName: "Append Stream")
                }
                NavigationLink(destination: scanResultStreamView()
                    .navigationBarTitle("Scan")) {
                    MenuRow(detailViewName: "Scan Stream")
                }
            }.navigationBarTitle("Streams")
            .navigationBarItems(leading: EditButton(), trailing: createStreamView)            
        }
        
    }
    
    var createStreamView: some View {
        NavigationLink(destination: UpdateStreamView(viewModel: UpdateStreamViewModel(streamModel: StreamModel<String>.new()))) {
            Image(systemName: "plus.circle").font(Font.system(size: 30))
        }
    }
    
    func filterStreamView() -> DoubleStreamView {
        DoubleStreamView(streamModel: viewModel.streamAModel, operatorTitle: "A.filter { $0 != 3 }", publisher: self.viewModel.streamA, convertingPublisher: { (publisher) -> AnyPublisher<String, Never> in
            publisher.filter { $0 != "3" }.eraseToAnyPublisher()
        })
    }
    
    func dropFirstStreamView() -> DoubleStreamView {
        DoubleStreamView(streamModel: viewModel.streamAModel, operatorTitle: "A.dropFirst(2)", publisher: self.viewModel.streamA, convertingPublisher: { (publisher) -> AnyPublisher<String, Never> in
            publisher.dropFirst(2).eraseToAnyPublisher()
        })
    }
    
    func zipResultStreamView() -> CombineResultStreamView {
        CombineResultStreamView(title: "Zip", stream1Id: self.viewModel.streamAModel.id, stream2Id: self.viewModel.streamBModel.id) { (numberPublisher, letterPublisher) -> AnyPublisher<(String, String), Never> in
            Publishers.Zip(numberPublisher, letterPublisher).eraseToAnyPublisher()
        }
    }
    
    func scanResultStreamView() -> DoubleStreamView {
        DoubleStreamView(streamModel: viewModel.streamAModel, operatorTitle: "A.scan(0) { $0 + $1 }", publisher: self.viewModel.streamA, convertingPublisher: { (publisher) -> AnyPublisher<String, Never> in
            publisher.map { Int($0)! }.scan(0) {
                $0 + $1
            }.map { String($0) }.eraseToAnyPublisher()
        })
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()//.previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
#endif
