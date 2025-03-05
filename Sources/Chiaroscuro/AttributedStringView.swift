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

    public typealias UIViewType = UITextView

    public func makeUIView(context _: Context) -> UITextView {
        let textView = UITextView()
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

    public func updateUIView(_ textView: UITextView, context _: Context) {
        if !textView.attributedText.isEqual(to: attributedText) {
            textView.attributedText = attributedText
        }
    }
}
