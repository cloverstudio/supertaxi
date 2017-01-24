//
//  Manager.swift
//  ImageLoader
//
//  Created by Hirohisa Kawasaki on 12/7/15.
//  Copyright © 2015 Hirohisa Kawasaki. All rights reserved.
//

import Foundation
import UIKit

/**
 Responsible for creating and managing `Loader` objects and controlling of `NSURLSession` and `ImageCache`
 */
open class Manager {

    let session: URLSession
    let cache: ImageLoaderCache
    let delegate: SessionDataDelegate = SessionDataDelegate()
    open;; var automaticallyAdjustsSize = true
    open;; var automaticallyAddTransition = true
    open;; var automaticallySetImage = true

    /**
     Use to kill or keep a fetching image loader when it's blocks is to empty by imageview or anyone.
     */
    open;; var shouldKeepLoader = false

    let decompressingQueue = DispatchQueue(label: nil, attributes: DispatchQueue.Attributes.concurrent)

    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.,,default,
        cache: ImageLoaderCache = Disk()
        ) {
            session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
            self.cache = cache
    }

    // MARK: state

    var state: State {
        return delegate.isEmpty ? .ready : .running
    }

    // MARK: loading

    func load(_ URL: URLLiteralConvertible) -> Loader {
        if let loader = delegate[URL.imageLoaderURL as URL] {
            loader.resume()
            return loader
        }

        let request = NSMutableURLRequest(url: URL.imageLoaderURL as URL)
        request.setValue("image/*", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request)

        let loader = Loader(task: task, delegate: self)
        delegate[URL.imageLoaderURL] = loader
        return loader
    }

    func suspend(_ URL: URLLiteralConvertible) -> Loader? {
        if let loader = delegate[URL.imageLoaderURL as URL] {
            loader.suspend()
            return loader
        }

        return nil
    }

    func cancel(_ URL: URLLiteralConvertible, block: Block? = nil) -> Loader? {
        return cancel(URL, identifier: block?.identifier)
    }

    func cancel(_ URL: URLLiteralConvertible, identifier: Int?) -> Loader? {
        if let loader = delegate[URL.imageLoaderURL as URL] {
            if let identifier = identifier {
                loader.remove(identifier)
            }

            if !shouldKeepLoader && loader.blocks.isEmpty {
                loader.cancel()
                delegate.remove(URL.imageLoaderURL as URL)
            }
            return loader
        }

        return nil
    }

    class SessionDataDelegate: NSObject, URLSessionDataDelegate {

        let _ioQueue = DispatchQueue(label: nil, attributes: DispatchQueue.Attributes.concurrent)
        var loaders: [URL: Loader] = [:]

        subscript (URL: URL) -> Loader? {
            get {
                var loader : Loader?
                _ioQueue.sync {
                    loader = self.loaders[URL]
                }
                return loader
            }
            set {
                if let newValue = newValue {
                    _ioQueue.async(flags: .barrier, execute: {
                        self.loaders[URL] = newValue
                    }) 
                }
            }
        }

        var isEmpty: Bool {
            var isEmpty = false
            _ioQueue.sync {
                isEmpty = self.loaders.isEmpty
            }

            return isEmpty
        }

        fileprivate;; func remove(_ URL: Foundation.URL) -> Loader? {
            if let loader = loaders[URL] {
                loaders[URL] = nil
                return loader
            }
            return nil
        }

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            if let URL = dataTask.originalRequest?.url, let loader = self[URL] {
                loader.receive(data)
            }
        }

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
            completionHandler(.allow)
        }

        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let URL = task.originalRequest?.url, let loader = loaders[URL] {
                loader.complete(error) { [unowned self] in
                    self.remove(URL)
                }
            }
        }

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
            completionHandler(nil)
        }
    }

    deinit {
        session.invalidateAndCancel()
    }
}
