//
//  String+GetFileName.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 17/05/23.
//

import Foundation

extension String {
    func getFileName() -> String {
        let url = URL(string: self)
        
        guard var domain = url?.host(percentEncoded: false) else { return "" }

        var domainParts = domain.split(separator: ".")

        if domainParts.first == "www" {
            _ = domainParts.removeFirst()
            domain = domainParts.joined(separator: ".")
        }

        guard var relativePath = url?.relativePath else { return domain + ".png" }
        
        relativePath = relativePath.split(separator: "/", omittingEmptySubsequences: true).joined(separator: "+")

        return domain + relativePath + ".png"
    }
}
