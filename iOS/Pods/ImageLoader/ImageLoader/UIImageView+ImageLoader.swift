//
//  UIImageView+ImageLoader.swift
//  ImageLoader
//
//  Created by Hirohisa Kawasaki on 10/17/14.
//  Copyright © 2014 Hirohisa Kawasaki. All rights reserved.
//

import Foundation
import UIKit

private var ImageLoaderURLKey = 0
private var ImageLoaderBlockKey = 0

/**
 Extension using ImageLoader sends a request, receives image and displays.
 */
extension UIImageView {

    public static var imageLoader = sharedInstance

    // MARK: - properties
    fileprivate static let _ioQueue = DispatchQueue(label: "swift.imageloader.queues.io", attributes: DispatchQueue.Attributes.concurrent)

    fileprivate var URL: Foundation.URL? {
        get {
            var URL: Foundation.URL?
            UIImageView._ioQueue.sync {
                URL = objc_getAssociatedObject(self, &ImageLoaderURLKey) as? Foundation.URL
            }

            return URL
        }
        set(newValue) {
            UIImageView._ioQueue.async(flags: .barrier, execute: {
                objc_setAssociatedObject(self, &ImageLoaderURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }) 
        }
    }

    fileprivate static let _Queue = DispatchQueue(label: "swift.imageloader.queues.request", attributes: [])

    // MARK: - functions
    public func load(_ URL: URLLiteralConvertible, placeholder: UIImage? = nil, completionHandler:CompletionHandler? = nil) {
        let block: () -> Void = { [weak self] in
            guard let wSelf = self else { return }

            wSelf.cancelLoading()
        }
        enqueue(block)

        image = placeholder

        imageLoader_load(URL.imageLoaderURL as URL, completionHandler: completionHandler)
    }

    public func cancelLoading() {
        if let URL = URL {
            UIImageView.imageLoader.cancel(URL, identifier: hash)
        }
    }

    // MARK: - private

    fileprivate func imageLoader_load(_ URL: Foundation.URL, completionHandler: CompletionHandler?) {
        let handler: CompletionHandler = { [weak self] URL, image, error, cacheType in
            if let wSelf = self, let thisURL = wSelf.URL, let image = image  where (thisURL == URL as URL) {
                wSelf.imageLoader_setImage(image, cacheType)
            }

            dispatch_main {
                completionHandler?(URL, image, error, cacheType)
            }
        }

        // caching
        if let data = UIImageView.imageLoader.cache[URL] {
            self.URL = URL
            handler(URL, UIImage.decode(data), nil, .cache)
            return
        }


        let identifier = hash
        let block: () -> Void = { [weak self] in
            guard let wSelf = self else { return }

            let block = Block(identifier: identifier, completionHandler: handler)
            UIImageView.imageLoader.load(URL).appendBlock(block)

            wSelf.URL = URL
        }

        enqueue(block)
    }

    fileprivate func enqueue(_ block: @escaping () -> Void) {
        UIImageView._Queue.async(execute: block)
    }

    fileprivate func imageLoader_setImage(_ image: UIImage, _ cacheType: CacheType) {
        dispatch_main { [weak self] in
            guard let wSelf = self else { return }
            if !UIImageView.imageLoader.automaticallySetImage { return }

            // Add a transition
            if UIImageView.imageLoader.automaticallyAddTransition && cacheType == CacheType.none {
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                wSelf.layer.add(transition, forKey: nil)
            }

            // Set an image
            if UIImageView.imageLoader.automaticallyAdjustsSize {
                wSelf.image = image.adjusts(wSelf.frame.size, scale: UIScreen.main.scale, contentMode: wSelf.contentMode)
            } else {
                wSelf.image = image
            }

        }
    }

}
