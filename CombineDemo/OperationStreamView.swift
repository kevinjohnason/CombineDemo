//
//  FlatMapStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/5/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct OperationStreamView: View {
    let numberPublisher = CombineService.shared.commonPublisher.eraseToAnyPublisher()
    let letterPublisher = CombineService.shared.serialLetterPublisher(seconds: 1).eraseToAnyPublisher()
    let operatorPublisher: AnyPublisher<String, Never>
    let stream1ViewModel: StreamViewModel<String>
    let stream2ViewModel: StreamViewModel<String>
    let operatorStreamViewModel: StreamViewModel<String>
    let title: String
    
    init(title: String, stream1Model: StreamModel<String>, stream2Model: StreamModel<String>, groupStreamModel: GroupOperationStreamModel) {
           self.title = title
           stream1ViewModel = StreamViewModel(title: stream1Model.name ?? "", description: stream1Model.sequenceDescription,  publisher: stream1Model.toPublisher())
        stream2ViewModel = StreamViewModel(title: stream2Model.name ?? "", description: stream2Model.sequenceDescription, publisher: stream2Model.toPublisher())
                            
        operatorPublisher = groupStreamModel.operationType.applyPublishers([stream1Model.toPublisher(), stream2Model.toPublisher()])
        operatorStreamViewModel = StreamViewModel(title: groupStreamModel.name ?? "", description: groupStreamModel.description ?? "", publisher: self.operatorPublisher)
       }
    
    
    var body: some View {
        VStack {
            SingleStreamView(viewModel: stream1ViewModel, displayActionButtons: false)
            SingleStreamView(viewModel: stream2ViewModel, color: .red, displayActionButtons: false)
            Spacer(minLength: 40)
            SingleStreamView(viewModel: operatorStreamViewModel, color: .yellow, displayActionButtons: false)
            HStack {
                CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                    self.stream1ViewModel.subscribe()
                    self.stream2ViewModel.subscribe()
                    self.operatorStreamViewModel.subscribe()
                }
                CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                    self.stream1ViewModel.cancel()
                    self.stream2ViewModel.cancel()
                    self.operatorStreamViewModel.cancel()
                }
            }.padding()
        }.navigationBarTitle(title)
    }
}

#if DEBUG
struct FlatMapStreamView_Previews: PreviewProvider {
    static var previews: some View {
        OperationStreamView(title: "", stream1Model: StreamModel<String>.new(), stream2Model: StreamModel<String>.new(), groupStreamModel: GroupOperationStreamModel(id: UUID(), name: nil, description: nil, streamModelIds: [], operationType: .append))
    }
}
#endif
