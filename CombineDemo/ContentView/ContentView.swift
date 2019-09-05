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
            VStack {
                List {
                    StreamListView(storedStreams: $viewModel.storedStreams)
                    NavigationLink(destination: OperationStreamView(title: "Merge", stream1Model: viewModel.streamAModel, stream2Model: viewModel.streamBModel) { (numberPublisher, letterPublisher) -> AnyPublisher<String, Never> in
                        Publishers.Merge(numberPublisher, letterPublisher).eraseToAnyPublisher()
                    }) {
                        MenuRow(detailViewName: "Merge Stream")
                    }
                    NavigationLink(destination: OperationStreamView(title: "FlatMap", stream1Model: viewModel.streamAModel, stream2Model: viewModel.streamBModel) { (numberPublisher, letterPublisher) -> AnyPublisher<String, Never> in
                        numberPublisher.flatMap { _ in letterPublisher }.eraseToAnyPublisher()
                    }) {
                        MenuRow(detailViewName: "FlatMap Stream")
                    }
                    NavigationLink(destination: zipResultStreamView()) {
                        MenuRow(detailViewName: "Zip Stream")
                    }
                    NavigationLink(destination: OperationStreamView(title: "Append", stream1Model: viewModel.streamAModel, stream2Model: viewModel.streamBModel) { (numberPublisher, letterPublisher) -> AnyPublisher<String, Never> in
                        numberPublisher.append(letterPublisher).eraseToAnyPublisher()
                    }) {
                        MenuRow(detailViewName: "Append Stream")
                    }
                    NavigationLink(destination: scanResultStreamView()) {
                        MenuRow(detailViewName: "Scan Stream")
                    }
                }
                
                Button("Reset") {
                    DataService.shared.resetStoredStream()
                }.frame(maxWidth: .infinity, maxHeight: 25)
                    .modifier(DemoButton(backgroundColor: .red))
            }.navigationBarTitle("Streams")
                .navigationBarItems(leading: EditButton(), trailing: createStreamView)
                .onAppear(perform: viewModel.refresh)
        }
        
    }
    
    var createStreamView: some View {
        NavigationLink(destination: UpdateStreamView(viewModel: UpdateStreamViewModel(streamModel: StreamModel<String>.new()))) {
            Image(systemName: "plus.circle").font(Font.system(size: 30))
        }
    }
    
    func zipResultStreamView() -> CombineResultStreamView {
        CombineResultStreamView(title: "Zip", stream1Model: self.viewModel.streamAModel, stream2Model: self.viewModel.streamBModel) { (numberPublisher, letterPublisher) -> AnyPublisher<(String, String), Never> in
            Publishers.Zip(numberPublisher, letterPublisher).eraseToAnyPublisher()
        }
    }
    
    func scanResultStreamView() -> DoubleStreamView {
        DoubleStreamView(streamModel: viewModel.streamAModel, operatorTitle: "Scan",operatorDescription: "A.scan(0) { $0 + $1 }", publisher: self.viewModel.streamA, convertingPublisher: { (publisher) -> AnyPublisher<String, Never> in
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
