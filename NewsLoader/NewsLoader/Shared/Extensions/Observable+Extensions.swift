//
//  Observable+Extensions.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 08/05/2023.
//

import RxSwift

extension Observable {
        
    //create shorthand version for returning observable from non-reactive function with async await support
    static func createAsync(_ function: @escaping () async throws -> Element) -> Observable<Element> {
        Observable.create { observer in
            let task = Task {
                do {
                    let result = try await function()
                    observer.on(.next(result))
                    observer.on(.completed)
                } catch {
                    observer.on(.error(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
}
