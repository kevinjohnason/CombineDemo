//
//  CombineResultStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/8/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct CombineResultStreamView: View {
    let numberPublisher = CombineService.shared.commonPublisher.eraseToAnyPublisher()
    let letterPublisher = CombineService.shared.serialLetterPublisher().eraseToAnyPublisher()
    let operatorPublisher: AnyPublisher<(String, String), Never>
    let numberStreamViewModel: StreamViewModel<String>
    let letterStreamViewModel: StreamViewModel<String>
    let resultStreamViewModel: StreamViewModel<(String, String)>
    
    init(title: String, streamOperator: (AnyPublisher<String, Never>, AnyPublisher<String, Never>) -> AnyPublisher<(String, String), Never>) {
        numberStreamViewModel = StreamViewModel(title: "A: Serial([1,2,3,4])", publisher: numberPublisher)
        letterStreamViewModel = StreamViewModel(title: "B: Serial([A,B,C,D])", publisher: letterPublisher)
        operatorPublisher = streamOperator(numberPublisher, letterPublisher)
        resultStreamViewModel = StreamViewModel(title: title, publisher: self.operatorPublisher)
    }
    
    var body: some View {
        VStack {
            SingleStreamView(viewModel: numberStreamViewModel)
            SingleStreamView(viewModel: letterStreamViewModel, color: .red)
            Spacer()
            CombineSingleStreamView(viewModel: resultStreamViewModel, displayActionButtons: false)
            
            HStack {
                CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                    self.numberStreamViewModel.subscribe()
                    self.letterStreamViewModel.subscribe()
                    self.resultStreamViewModel.subscribe()
                }
                CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                    self.numberStreamViewModel.cancel()
                    self.letterStreamViewModel.cancel()
                    self.resultStreamViewModel.cancel()
                }
            }.padding()
        }
    }
}

#if DEBUG
struct CombineResultStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CombineResultStreamView(title: "") { (_, _) -> AnyPublisher<(String, String), Never> in
            return Empty().eraseToAnyPublisher()
        }
    }
}
#endif
