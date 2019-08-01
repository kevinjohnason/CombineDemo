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
    @State var percent: CGFloat = 0
    
    @State var text = ""
            
    @State var cancellable: Cancellable?
    
    var body: some View {
        VStack {
            BallTunnelView(percent: $percent, text: $text)
            
            HStack {
                Button("Subscribe") {
                    self.cancellable = CombineService.shared.intervalSerialNumberPublisher()
                        .sink(receiveCompletion: { (_) in
                    }) { (value) in
                        self.text = String(value)
                        self.percent = 0
                        withAnimation(.easeInOut(duration: 1.5)) {
                                                self.percent = 1
                                            }
                        
                    }
                    
                    print(self.cancellable!)
                }
                
                Button("Cancel") {
                    self.cancellable?.cancel()
                    self.percent = 0                    
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
