//
//  TextSize.swift
//  WorkerBee
//
//  Created by nixzhu on 2017/5/26.
//  Copyright © 2017年 nixWork. All rights reserved.
//

import UIKit

public struct TextSize {

    private struct CacheEntry: Hashable {
        let text: String
        let font: UIFont
        let width: CGFloat
        let insets: UIEdgeInsets

        var hashValue: Int {
            return text.hashValue ^ font.hashValue ^ Int(width) ^ Int(insets.top) ^ Int(insets.left) ^ Int(insets.bottom) ^ Int(insets.right)
        }

        static func ==(lhs: CacheEntry, rhs: CacheEntry) -> Bool {
            return lhs.width == rhs.width && lhs.insets == rhs.insets && lhs.text == rhs.text && lhs.font == rhs.font
        }
    }

    private struct CacheEntry2: Hashable {
        let text: String
        let font: UIFont
        let height: CGFloat
        let insets: UIEdgeInsets

        var hashValue: Int {
            return text.hashValue ^ font.hashValue ^ Int(height) ^ Int(insets.top) ^ Int(insets.left) ^ Int(insets.bottom) ^ Int(insets.right)
        }

        static func ==(lhs: CacheEntry2, rhs: CacheEntry2) -> Bool {
            return lhs.height == rhs.height && lhs.insets == rhs.insets && lhs.text == rhs.text && lhs.font == rhs.font
        }
    }

    private static var cache = [CacheEntry: CGRect]() {
        didSet {
            assert(Thread.isMainThread)
        }
    }

    private static var cache2 = [CacheEntry2: CGRect]() {
        didSet {
            assert(Thread.isMainThread)
        }
    }

    public static func size(text: String, font: UIFont, width: CGFloat, insets: UIEdgeInsets = .zero) -> CGSize {
        let key = CacheEntry(text: text, font: font, width: width, insets: insets)
        if let hit = cache[key] {
            return hit.size
        }
        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSFontAttributeName: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        var bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        bounds.size.width = width
        bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
        cache[key] = bounds
        return bounds.size
    }

    public static func size(text: String, font: UIFont, height: CGFloat, insets: UIEdgeInsets = .zero) -> CGSize {
        let key = CacheEntry2(text: text, font: font, height: height, insets: insets)
        if let hit = cache2[key] {
            return hit.size
        }
        let constrainedSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height - insets.top - insets.bottom)
        let attributes = [NSFontAttributeName: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        var bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        bounds.size.width = ceil(bounds.width + insets.left + insets.right)
        bounds.size.height = height
        cache2[key] = bounds
        return bounds.size
    }
}
