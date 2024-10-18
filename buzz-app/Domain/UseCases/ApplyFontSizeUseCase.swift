//
//  ChangeFontSizeUseCase.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 17/10/24.
//

import AppKit
import Foundation

struct ApplyFontSizeUseCase {
    func execute(text: NSAttributedString, fontSize: CGFloat) -> NSAttributedString {
        var mutableAttrText = NSMutableAttributedString(attributedString: text)
        let fontValue = NSFont.systemFont(ofSize: fontSize)

        mutableAttrText.enumerateAttribute(.font, in: NSRange(location: 0, length: text.length), options: []) {
            _, range, _ in
            mutableAttrText.addAttribute(.font, value: fontValue, range: range)
        }

        return mutableAttrText
    }
}
