//
//  NativeAdView.swift
//  SwiftUIDemo
//
//  Created by Allen on 12/20/24.
//
import GoogleMobileAds
import SwiftUI

public struct NativeAdView: UIViewRepresentable {
    public typealias UIViewType = GADNativeAdView

    let width: CGFloat
    @Binding var height: CGFloat?
    // Observer to update the UIView when the native ad value changes.
    @ObservedObject var nativeViewModel: NativeAdViewModel

    public func makeUIView(context: Context) -> GADNativeAdView {
        let nativeAdView = Bundle.module.loadNibNamed(
            "NativeAdView",
            owner: nil,
            options: nil
        )?.first as! GADNativeAdView

        // Add width constraint
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(
            item: nativeAdView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: width
        )
        nativeAdView.addConstraint(widthConstraint)

        // UI
        nativeAdView.callToActionView?.layer.cornerRadius = 8
        nativeAdView.callToActionView?.layer.masksToBounds = true
        return nativeAdView
    }

    public func updateUIView(_ nativeAdView: GADNativeAdView, context: Context) {
        updateNativeAdView(nativeAdView)
    }

    public func updateNativeAdView(_ nativeAdView: GADNativeAdView) {
        guard let nativeAd = nativeViewModel.nativeAd else { return }

        // Each UI property is configurable using your native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline

        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)

        // For the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        nativeAdView.callToActionView?.layer.cornerRadius = 8
        nativeAdView.callToActionView?.layer.masksToBounds = true

        // Associate the native ad view with the native ad object. This is required to make the ad
        // clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd

        // update height
        nativeAdView.setNeedsLayout()
        nativeAdView.layoutIfNeeded()
        DispatchQueue.main.async {
            withAnimation(.spring) {
                self.height = nativeAdView.bounds.height
            }
        }
    }

    // [END create_native_ad_view]

    private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(resource: .stars5)
        } else if rating >= 4.5 {
            return UIImage(resource: .stars45)
        } else if rating >= 4 {
            return UIImage(resource: .stars4)
        } else if rating >= 3.5 {
            return UIImage(resource: .stars35)
        } else {
            return nil
        }
    }
}
