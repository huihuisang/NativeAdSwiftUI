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

import GoogleMobileAds
import NativeAdSwiftUI
import SwiftUI

// MARK: - NativeContentView

// [START add_view_model_to_view]
struct NativeContentView: View {
    // Single source of truth for the native ad data.
    @StateObject private var nativeViewModel = NativeAdViewModel(adUnitID: "ca-app-pub-3940256099942544/3986624511")
    // [START_EXCLUDE silent]
    let navigationTitle: String
    // [END_EXCLUDE]

    var body: some View {
        VStack(spacing: 20) {
            if nativeViewModel.nativeAd != nil {
                NativeAdCardView(nativeViewModel: nativeViewModel, width: UIScreen.main.bounds.width - 32)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Text(nativeViewModel.nativeAd?.mediaContent.hasVideoContent == true
                ? "Ad contains a video asset." : "Ad does not contain a video."
            )
            .frame(maxWidth: .infinity)
            .foregroundColor(.gray)
            .opacity(nativeViewModel.nativeAd == nil ? 0 : 1)

            Button("Refresh Ad") {
                refreshAd()
            }

            Text(
                "SDK Version:"
                    + "\(GADGetStringFromVersionNumber(GADMobileAds.sharedInstance().versionNumber))")
        }
        .padding()

        .onAppear {
            refreshAd()
        }
        .navigationTitle(navigationTitle)
    }

    private func refreshAd() {
        nativeViewModel.refreshAd()
    }
}

// MARK: - NativeContentView_Previews

struct NativeContentView_Previews: PreviewProvider {
    static var previews: some View {
        NativeContentView(navigationTitle: "Native")
    }
}

// [START create_native_ad_view]

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

// MARK: - SizePreferenceKey

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
