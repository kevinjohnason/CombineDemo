//
//  StreamListView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct StreamListView: View {
    
    @State var storedStreams = DataService.shared.storedStreams {
        didSet {
            DataService.shared.storedStreams = self.storedStreams
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(storedStreams) { stream in
                    NavigationLink(destination: SingleStreamView(viewModel: DynamicStreamViewModel(streamId: stream.id))) {
                           MenuRow(detailViewName: stream.name)
                    }
                }.onDelete { (index) in
                    guard let removingItem = index.first else {
                        return
                    }
                    self.storedStreams.remove(at: removingItem)
                }
            }
            .navigationBarTitle("Streams")
            .navigationBarItems(trailing: createStreamView)
        }
    }
    
    var createStreamView: some View {
        NavigationLink(destination: UpdateStreamView(viewModel: UpdateStreamViewModel(streamModel: StreamModel<String>.new()))) {
            Image(systemName: "plus.circle").font(Font.system(size: 30))
        }
    }
}

struct StreamListView_Previews: PreviewProvider {
    static var previews: some View {
        StreamListView()
    }
}
