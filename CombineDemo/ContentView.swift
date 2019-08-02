//
//  ContentView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct ContentView: View {
        
    let publisher = CombineService.shared.commonPublisher
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SingleStreamView(viewModel: SingleStreamViewModel(publisher: publisher))) {
                    MenuRow(detailViewName: "Serial Stream")
                }
                NavigationLink(destination: MergeStreamView()) {
                    MenuRow(detailViewName: "Merge Stream")
                }
            }
        }
        .navigationBarTitle(Text("Combine Demo").foregroundColor(.green))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()//.previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
#endif
