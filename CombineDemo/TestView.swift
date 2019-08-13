//
//  TestView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/12/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct TestView: View {
    
    @State var enable: Bool = false
    
    init() {
        
    }
    
    var body: some View {
        VStack {
            Button("Tap here") {
                
                withAnimation(.spring()) {
                    self.enable.toggle()
                }

            }
            if enable {
                Text("Hello World!")
                    .transition(.move(edge: .leading))
            }
        }
    }
}

#if DEBUG
struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
#endif
