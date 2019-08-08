//
//  CombineStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/7/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct CombineSingleStreamView: View {
    
    @ObservedObject var viewModel: CombineSingleStreamViewModel
    
    var displayActionButtons: Bool = true
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text(viewModel.title)
            .font(.system(.headline, design: .monospaced))
            .lineLimit(nil).padding()
            
            DoubleBallTunnelView(percent: $viewModel.percent, text1: $viewModel.text1, text2: $viewModel.text2, animate: true, historialTexts: $viewModel.previousTexts, color: .green, animationSecond: viewModel.animationSeconds)
            
            if displayActionButtons {
                HStack {
                    CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                      self.viewModel.subscribe()
                    }
                    
                    CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                      self.viewModel.cancel()
                    }
                }.padding()
            }
            
            
            Spacer()
        }
    }
}

#if DEBUG
struct CombineSingleStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CombineSingleStreamView(viewModel: CombineSingleStreamViewModel(title: "", publisher: Empty().eraseToAnyPublisher()))
    }
}
#endif
