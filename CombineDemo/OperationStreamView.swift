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
    let numberPublisher = CombineService.shared.commonPublisher.share().eraseToAnyPublisher()
    let letterPublisher = CombineService.shared.serialLetterPublisher().share().eraseToAnyPublisher()
    let mergesPublisher: AnyPublisher<String, Error>
    let numberStreamViewModel: SingleStreamViewModel
    let letterStreamViewModel: SingleStreamViewModel
    let mergeStreamViewModel: SingleStreamViewModel
    
    init(streamOperator: (AnyPublisher<String, Error>, AnyPublisher<String, Error>) -> AnyPublisher<String, Error>) {
        numberStreamViewModel = SingleStreamViewModel(title: "numberPublisher: Just([1,2,3,4])", publisher: numberPublisher)
        letterStreamViewModel = SingleStreamViewModel(title: "letterPublisher: Just([A,B,C,D])", publisher: letterPublisher)
        mergesPublisher = streamOperator(numberPublisher, letterPublisher)
        mergeStreamViewModel = SingleStreamViewModel(title: "Publishers.Merge(numberPublisher, letterPublisher)", publisher: self.mergesPublisher)
    }
    
    var body: some View {
        VStack {
            SingleStreamView(viewModel: numberStreamViewModel)
            SingleStreamView(viewModel: letterStreamViewModel, color: .red)
            Spacer(minLength: 80)
            SingleStreamView(viewModel: mergeStreamViewModel, color: .yellow, displayActionButtons: false)
            HStack {
                CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                    self.numberStreamViewModel.subscribe()
                    self.letterStreamViewModel.subscribe()
                    self.mergeStreamViewModel.subscribe()
                                   }
                CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                                self.numberStreamViewModel.cancel()
                                self.letterStreamViewModel.cancel()
                                self.mergeStreamViewModel.cancel()
                    }
            }            
        }
    }
}

#if DEBUG
struct FlatMapStreamView_Previews: PreviewProvider {
    static var previews: some View {
        OperationStreamView { (_, _) -> AnyPublisher<String, Error> in
            Just("").tryMap { $0 }.eraseToAnyPublisher()
        }
    }
}
#endif
