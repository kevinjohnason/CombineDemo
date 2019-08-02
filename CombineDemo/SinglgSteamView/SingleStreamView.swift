//
//  SingleStreamView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.move(edge: .trailing)
    }
    

}

struct SingleStreamView: View {
        
    @ObservedObject var viewModel = SingleStreamViewModel()
    
    var body: some View {
        VStack {
            BallTunnelView(percent: $viewModel.percent, text: $viewModel.text)            
            
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
        SingleStreamView().previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
#endif
