//
//  CombineStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/7/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct CombineStreamView: View {
    var body: some View {
     
        
        VStack(spacing: 30) {
            Spacer()
            Text("Combine Latest")
                .font(.system(.headline, design: .monospaced))
                .lineLimit(nil).padding()
            //BallTunnelView(percent: $viewModel.percent, text: $viewModel.text, color: color, animationSecond: viewModel.animationSeconds)
            
            DoubleBallTunnelView(percent: .constant(0.5), text1: .constant("1"), text2: .constant("A"), animate: true, historialTexts: .constant([]), color: .green)            
            Spacer()
        }
    }
}

#if DEBUG
struct CombineStreamView_Previews: PreviewProvider {
    static var previews: some View {
        CombineStreamView()
    }
}
#endif
