//
//  ViewModelType.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 03/05/2023.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
