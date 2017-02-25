//
//  WebView+ZhihuDaily.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/2/13.
//  Copyright © 2017年 Jin. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {

    func loadLocalFile(_ fileURL: URL) {
        if #available(iOS 9.0, *) {
            self.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        } else {
            do {
                let url = try fileURLForBuggyWKWebView8(fileURL: fileURL)
				self.load(URLRequest(url: url))
            } catch let error as NSError {
				print("Error: \(error.description)")
            }
        }
    }

    private func fileURLForBuggyWKWebView8(fileURL: URL) throws -> URL {
        // Some safety checks
        if !fileURL.isFileURL {
            throw NSError(domain: "BuggyWKWebViewDomain", code: 1001, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("URL must be a file URL", comment: "")])
        }
        let _ = try! fileURL.checkResourceIsReachable()

        // Create "/temp/www" directory
        let fm = FileManager.default
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("www")
        try! fm.createDirectory(at: tempDirURL, withIntermediateDirectories: true, attributes: nil)

        // copy given file to temp directory
        let dstURL = tempDirURL.appendingPathComponent(fileURL.lastPathComponent)
        let _ = try? fm.removeItem(at: dstURL)
        try! fm.copyItem(at: fileURL, to: dstURL)

        return dstURL
    }
}
