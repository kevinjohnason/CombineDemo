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
            Text("")
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
