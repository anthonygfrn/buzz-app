//
//  Strings.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 22/10/24.
//

import Foundation

extension String {
    func ranges(of pattern: String) -> [Range<String.Index>] {
        let regex = try! NSRegularExpression(pattern: pattern)
        let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        return results.compactMap { Range($0.range, in: self) }
    }
}

