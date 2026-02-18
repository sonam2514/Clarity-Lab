//
//  SwiftUIView.swift
//  Clarity Lab
//
//  Created by Student on 17/02/26.
//

import SwiftUI




struct MainContainerView: View {
    
    @State private var logs: [SessionLog] = []
    
    var body: some View {
        NavigationStack {
            WelcomeView(logs: $logs)
        }
        .preferredColorScheme(.dark)
    }
}


#Preview {
    MainContainerView()
}
