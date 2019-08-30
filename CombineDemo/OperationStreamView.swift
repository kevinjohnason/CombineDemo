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
    let numberStreamViewModel: StreamViewModel<String>
    let letterStreamViewModel: StreamViewModel<String>
    let operatorStreamViewModel: StreamViewModel<String>
    
    init(title: String, streamOperator: (AnyPublisher<String, Never>, AnyPublisher<String, Never>) -> AnyPublisher<String, Never>) {
        numberStreamViewModel = StreamViewModel(title: "A: Serial([1,2,3,4])", description: "A: Serial([1,2,3,4])",  publisher: numberPublisher)
        letterStreamViewModel = StreamViewModel(title: "B: Serial([A,B,C,D])", description: "B: Serial([A,B,C,D])", publisher: letterPublisher)
        operatorPublisher = streamOperator(numberPublisher, letterPublisher)
        operatorStreamViewModel = StreamViewModel(title: title, description: title, publisher: self.operatorPublisher)
    }
    
    var body: some View {
        VStack {
            SingleStreamView(viewModel: numberStreamViewModel, displayActionButtons: false)
            SingleStreamView(viewModel: letterStreamViewModel, color: .red, displayActionButtons: false)
            Spacer(minLength: 40)
            SingleStreamView(viewModel: operatorStreamViewModel, color: .yellow, displayActionButtons: false)
            HStack {
                CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                    self.numberStreamViewModel.subscribe()
                    self.letterStreamViewModel.subscribe()
                    self.operatorStreamViewModel.subscribe()
                }
                CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                    self.numberStreamViewModel.cancel()
                    self.letterStreamViewModel.cancel()
                    self.operatorStreamViewModel.cancel()
                }
            }.padding()
        }
    }
}

#if DEBUG
struct FlatMapStreamView_Previews: PreviewProvider {
    static var previews: some View {
        OperationStreamView(title: "") { (_, _) -> AnyPublisher<String, Never> in
            Just("").eraseToAnyPublisher()
        }
    }
}
#endif
