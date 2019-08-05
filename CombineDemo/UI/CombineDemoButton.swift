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
            Button(text, action: buttonAction)
                           .padding(10)
                           .foregroundColor(Color.white)
                           .background(backgroundColor)
                           .cornerRadius(10)
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
