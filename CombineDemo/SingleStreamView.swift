//
//  SingleStreamView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct SingleStreamView: View {
    @State var percent: CGFloat = 0
    
    @State var text = ""
    
    @State var counter = 0
    
    var body: some View {
        VStack {
            BallTunnelView(percent: $percent, text: $text)
            
            HStack {
                Button("Next") {
                    self.percent = 0
                    self.counter += 1
                    self.text = String(self.counter)
                    withAnimation(.easeInOut(duration: 1.5)) {
                        self.percent = 1
                    }
                }
                
                Button("Reset") {
                    self.counter = 0
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
