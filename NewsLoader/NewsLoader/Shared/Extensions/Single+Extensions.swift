//
//  Single+Extensions.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 14/05/2023.
//

import RxSwift

extension Single {
        
    //create shorthand version for returning single from non-reactive function with async await support
    static func createAsync(_ function: @escaping () async throws -> Element) -> Single<Element> {
        .create { observer in
            let task = Task {
                do {
                    observer(.success(try await function()))
                } catch {
                    observer(.failure(error))
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
