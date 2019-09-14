//
//  MultiStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 9/12/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct MultiStreamView: View {
    let streamViewModels: [StreamViewModel<String>]
    let streamTitle: String
            
    init(streamTitle: String, sourceStreamModel: StreamModel<String>, operatorItem: OperatorItem) {
        self.streamTitle = streamTitle
                        
        let sourceViewModel = StreamViewModel(title: sourceStreamModel.name ?? "",
                                              description: sourceStreamModel.sequenceDescription,
                                              publisher: sourceStreamModel.toPublisher())
        
        var streamViewModels: [StreamViewModel<String>] = [sourceViewModel]
        
        var currentOperatorItem: OperatorItem?  = operatorItem
        var currentPublisher: AnyPublisher<String, Never>? = sourceStreamModel.toPublisher()
        while currentOperatorItem != nil {
            let newPublisher = currentOperatorItem!.applyPublisher(currentPublisher!)
            streamViewModels.append(StreamViewModel(title:
                currentOperatorItem!.description, description: currentOperatorItem!.description, publisher: newPublisher))
            currentOperatorItem = currentOperatorItem?.next
            currentPublisher = newPublisher
        }
                
        self.streamViewModels = streamViewModels
    }
    
    var body: some View {
        VStack {
            ForEach(streamViewModels, id: \.title) { streamView in
                SingleStreamView(viewModel: streamView, color: .green, displayActionButtons: false)
            }
            HStack {
                CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                    self.streamViewModels.forEach {
                        $0.subscribe()
                    }
                }
                CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                    self.streamViewModels.forEach {
                        $0.cancel()
                    }
                }
            }.padding()
        }.navigationBarTitle(streamTitle)
    }
}

struct MultiStreamView_Previews: PreviewProvider {
    static var previews: some View {
        MultiStreamView(streamTitle: "",
                        sourceStreamModel: StreamModel<String>.new(),
                        operatorItem: OperatorItem(type: .delay))
    }
}
