//
//  SingleStreamView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct SingleStreamView: View {
        
    @ObservedObject var viewModel: SingleStreamViewModel
    
    var color: Color = .green
    
    var body: some View {
        VStack {
            BallTunnelView(percent: $viewModel.percent, text: $viewModel.text, color: color, animationSecond: viewModel.animationSeconds)
            
            HStack {
                Button("Subscribe") {
                    self.viewModel.subscribe()
                }
                Button("Cancel") {
                    self.viewModel.cancel()
                }
            }
        }
    }
}

#if DEBUG
struct SingleStreamView_Previews: PreviewProvider {
    static var previews: some View {
        SingleStreamView(viewModel: SingleStreamViewModel(publisher: CombineService.shared.commonPublisher))
        //.previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
#endif
