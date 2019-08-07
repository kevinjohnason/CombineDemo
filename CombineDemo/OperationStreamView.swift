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
    let letterPublisher = CombineService.shared.serialLetterPublisher().eraseToAnyPublisher()
    let mergesPublisher: AnyPublisher<String, Never>
    let numberStreamViewModel: SingleStreamViewModel
    let letterStreamViewModel: SingleStreamViewModel
    let operatorStreamViewModel: SingleStreamViewModel
    
    init(streamOperator: (AnyPublisher<String, Never>, AnyPublisher<String, Never>) -> AnyPublisher<String, Never>) {
        numberStreamViewModel = SingleStreamViewModel(title: "Serial([1,2,3,4])", publisher: numberPublisher)
        letterStreamViewModel = SingleStreamViewModel(title: "Serial([A,B,C,D])", publisher: letterPublisher)
        mergesPublisher = streamOperator(numberPublisher, letterPublisher)
        operatorStreamViewModel = SingleStreamViewModel(title: "Publishers.Merge(numberPublisher, letterPublisher)", publisher: self.mergesPublisher)
    }
    
    var body: some View {
        VStack {
            SingleStreamView(viewModel: numberStreamViewModel)
            SingleStreamView(viewModel: letterStreamViewModel, color: .red)
            Spacer(minLength: 80)
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
            }            
        }
    }
}

#if DEBUG
struct FlatMapStreamView_Previews: PreviewProvider {
    static var previews: some View {
        OperationStreamView { (_, _) -> AnyPublisher<String, Never> in
            Just("").eraseToAnyPublisher()
        }
    }
}
#endif
