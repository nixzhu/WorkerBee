//
//  TextSize.swift
//  WorkerBee
//
//  Created by nixzhu on 2017/5/26.
//  Copyright © 2017年 nixWork. All rights reserved.
//

import UIKit

public struct TextSize {

    private struct FixedWidthCacheEntry: Hashable {
        let text: String
        let font: UIFont
        let width: CGFloat
        let insets: UIEdgeInsets

        var hashValue: Int {
            return text.hashValue ^ font.hashValue ^ Int(width) ^ Int(insets.top) ^ Int(insets.left) ^ Int(insets.bottom) ^ Int(insets.right)
        }

        static func ==(lhs: FixedWidthCacheEntry, rhs: FixedWidthCacheEntry) -> Bool {
            return lhs.width == rhs.width && lhs.insets == rhs.insets && lhs.text == rhs.text && lhs.font == rhs.font
        }
    }

    private struct FixedHeightCacheEntry: Hashable {
        let text: String
        let font: UIFont
        let height: CGFloat
        let insets: UIEdgeInsets

        var hashValue: Int {
            return text.hashValue ^ font.hashValue ^ Int(height) ^ Int(insets.top) ^ Int(insets.left) ^ Int(insets.bottom) ^ Int(insets.right)
        }

        static func ==(lhs: FixedHeightCacheEntry, rhs: FixedHeightCacheEntry) -> Bool {
            return lhs.height == rhs.height && lhs.insets == rhs.insets && lhs.text == rhs.text && lhs.font == rhs.font
        }
    }

    private static var fixedWidthCache = [FixedWidthCacheEntry: CGFloat]() {
        didSet {
            assert(Thread.isMainThread)
        }
    }

    private static var fixedHeightCache = [FixedHeightCacheEntry: CGFloat]() {
        didSet {
            assert(Thread.isMainThread)
        }
    }

    public static func height(text: String, font: UIFont, width: CGFloat, insets: UIEdgeInsets = .zero) -> CGFloat {
        let key = FixedWidthCacheEntry(text: text, font: font, width: width, insets: insets)
        if let hit = fixedWidthCache[key] {
            return hit
        }
        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSFontAttributeName: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        let height = ceil(bounds.height + insets.top + insets.bottom)
        fixedWidthCache[key] = height
        return height
    }

    public static func width(text: String, font: UIFont, insets: UIEdgeInsets = .zero) -> CGFloat {
        let key = FixedHeightCacheEntry(text: text, font: font, height: 0, insets: insets)
        if let hit = fixedHeightCache[key] {
            return hit
        }
        let constrainedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let attributes = [NSFontAttributeName: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        let width = ceil(bounds.width + insets.left + insets.right)
        fixedHeightCache[key] = width
        return width
    }
}
