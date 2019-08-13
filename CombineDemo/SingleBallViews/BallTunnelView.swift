//
//  BallTunnelView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/2/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct BallTunnelView: View {
    @State var animate: Bool  = false
    @Binding var values: [String]
    var color: Color = .green
    
    var animationSecond: Double = 2
    
    var ballRadius: CGFloat = 48
        
    var body: some View {
        GeometryReader { tunnelGeometry in
            HStack(spacing: 0) {
                Spacer()
                ForEach(self.values.reversed(), id: \.self) { text in
                    BallView(forgroundColor: .white, backgroundColor: self.color, text: .constant(text))
                        .frame(width: self.ballRadius, height: self.ballRadius, alignment: .center)
                        .transition(.asymmetric(insertion: .offset(x: -tunnelGeometry.size.width, y: 0), removal: .offset(x: tunnelGeometry.size.width, y: 0)))
                }
            }
            .frame(minWidth: tunnelGeometry.size.width, minHeight: self.ballRadius, alignment: .trailing)
            .padding([.top, .bottom], 5)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0))
            .animation(.easeInOut(duration: self.animationSecond))
        }
    }
}

#if DEBUG
struct BallTunnelView_Previews: PreviewProvider {
    static var previews: some View {
        BallTunnelView(values: .constant([]))
    }
}
#endif
