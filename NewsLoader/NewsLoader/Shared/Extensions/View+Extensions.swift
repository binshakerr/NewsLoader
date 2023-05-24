//
//  View+Extensions.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 23/05/2023.
//

import SwiftUI

extension View {
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
    func onRefresh(isRefreshing: Bool, perform action: @escaping (() -> Void)) -> some View {
        modifier(RefreshableScrollViewModifier(isRefreshing: isRefreshing, action: action))
    }
}
