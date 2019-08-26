//
//  CombineDemoButton.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/5/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct CombineDemoButton: View {
    
    let text: String
    
    let backgroundColor: Color
    
    let buttonAction: () -> Void
    
    var body: some View {
        Button(text, action: buttonAction).font(.footnote)
                           .padding(10)
                           .foregroundColor(Color.white)
                           .frame(minWidth: 80)
                           .background(backgroundColor)
                           .cornerRadius(12)
            
    }
}

#if DEBUG
struct CombineDemoButton_Previews: PreviewProvider {
    static var previews: some View {
        CombineDemoButton(text: "", backgroundColor: .blue) {
            
        }
    }
}
#endif
