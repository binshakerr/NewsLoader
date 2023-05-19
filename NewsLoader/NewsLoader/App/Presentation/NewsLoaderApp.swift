//
//  NewsLoaderApp.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 20/05/2023.
//

import SwiftUI

@main
struct NewsLoaderApp: App {
    
    @EnvironmentObject var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
        }
    }
}
