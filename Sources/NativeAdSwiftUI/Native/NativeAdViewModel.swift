//
//  Copyright 2022 Google LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

// [START create_view_model]
import GoogleMobileAds
import SwiftUI

// MARK: - NativeAdViewModel

public class NativeAdViewModel: NSObject, ObservableObject, GADNativeAdLoaderDelegate {
    var adUnitID: String

    public init(adUnitID: String) {
        self.adUnitID = adUnitID
    }

    @Published public var nativeAd: GADNativeAd?
    private var adLoader: GADAdLoader!

    public func refreshAd() {
        adLoader = GADAdLoader(
            adUnitID: adUnitID,
            // The UIViewController parameter is optional.
            rootViewController: nil,
            adTypes: [.native], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }

    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        // Native ad data changes are published to its subscribers.
        withAnimation(.spring) {
            self.nativeAd = nativeAd
            nativeAd.delegate = self
        }
    }

    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}

// MARK: GADNativeAdDelegate

// [END create_view_model]

extension NativeAdViewModel: GADNativeAdDelegate {
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }

    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }

    public func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }

    public func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }

    public func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
}
