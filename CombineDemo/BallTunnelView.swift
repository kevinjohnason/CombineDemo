//
//  BallTunnelView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct BallTunnelView: View {
    
    @Binding var percent: CGFloat
    @Binding var text: String
    
    var offset: CGFloat {
        return -50 + percent * 500
    }
    
    @State var animate: Bool  = false
    
    
    var offsetAnimation: Animation? {
        if percent == 0 {
            return nil
        }
        return .easeInOut(duration: 1.5)
    }
    
    var body: some View {
        BallView(forgroundColor: .white, backgroundColor: .green, text: $text)
                    .animation(nil)
                    .offset(x: offset)
                    .animation(offsetAnimation)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray)
         
    }
    
}

#if DEBUG
struct BallTunnelView_Previews: PreviewProvider {
    static var previews: some View {
        let tunnelView = BallTunnelView(percent: .constant(0), text: .constant("A"))
        
        return tunnelView
    }
}
#endif
