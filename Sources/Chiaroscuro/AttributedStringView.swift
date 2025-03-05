import Foundation
import SwiftUI
import UIKit

/// A SwiftUI wrapper for UITextView that displays attributed strings.
public struct AttributedStringView: UIViewRepresentable {
    /// The attributed string to display
    public let attributedText: NSAttributedString

    /// Creates a new AttributedStringView
    /// - Parameter attributedText: The attributed string to display
    public init(attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }
    
    public typealias UIViewType = CachingTextView

    public func makeUIView(context _: Context) -> CachingTextView {
        let textView = CachingTextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.attributedText = attributedText
        textView.backgroundColor = .clear
        textView.contentInset = .zero
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }

    public func updateUIView(_ textView: CachingTextView, context _: Context) {
        if !textView.attributedText.isEqual(to: attributedText) {
            textView.attributedText = attributedText
        }
    }
}

/// UITextView subclass that caches intrinsic content size.
public class CachingTextView: UITextView {
    private var cachedIntrinsicContentSize: CGSize?
    private var lastBoundsWidth: CGFloat = 0

    override public var frame: CGRect {
        didSet {
            if frame.width != oldValue.width {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override public var intrinsicContentSize: CGSize {
        if lastBoundsWidth != bounds.width || cachedIntrinsicContentSize == nil {
            lastBoundsWidth = bounds.width
            let size = sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
            cachedIntrinsicContentSize = CGSize(width: size.width, height: size.height)
        }
        return cachedIntrinsicContentSize!
    }

    override public var attributedText: NSAttributedString! {
        didSet {
            if !oldValue.isEqual(to: attributedText) {
                cachedIntrinsicContentSize = nil
            }
        }
    }
}
