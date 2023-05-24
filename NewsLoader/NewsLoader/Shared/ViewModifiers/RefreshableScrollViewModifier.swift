//
//  RefreshableScrollViewModifier.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 23/05/2023.
//

import SwiftUI

struct RefreshableScrollViewModifier: ViewModifier {
    
    @State var isRefreshing: Bool
    var action: () -> Void
    
    func body(content: Content) -> some View {
        RefreshableScrollView(action: action) {
            if isRefreshing {
                VStack {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    content
                }
            } else {
                content
            }
        }
    }
}
