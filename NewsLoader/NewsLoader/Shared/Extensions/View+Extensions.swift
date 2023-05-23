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
}
