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

import SwiftUI

// MARK: - NativeAdCardView

public struct NativeAdCardView: View {
    public init(nativeViewModel: NativeAdViewModel = NativeAdViewModel(adUnitID: "ca-app-pub-3940256099942544/3986624511"),
                countdown: Int = 3,
                width: CGFloat? = nil)
    {
        _nativeViewModel = StateObject(wrappedValue: nativeViewModel)
        _countdownTimer = StateObject(wrappedValue: CountdownTimer(countdown))
        _width = State(initialValue: width)
    }

    @StateObject private var countdownTimer = CountdownTimer()
    @StateObject private var nativeViewModel: NativeAdViewModel
    @State private var width: CGFloat? = nil
    @State private var height: CGFloat? = nil
    private let padding: CGFloat = 16

    public var body: some View {
        VStack(spacing: 16) {
            NativeAdView(width: (width ?? 0) - padding * 2, height: $height, nativeViewModel: nativeViewModel)
                .frame(height: height)
                .fixedSize(horizontal: false, vertical: true)
            Button {
                if countdownTimer.isComplete {
                    withAnimation(.spring) {
                        nativeViewModel.nativeAd = nil
                    }
                }
            } label: {
                Group {
                    if !countdownTimer.isComplete {
                        Text("ad.auto-close.label-\(countdownTimer.timeLeft)", bundle: .module)
                    } else {
                        Text("ad.close.label", bundle: .module)
                            .underline()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .font(.caption2)
                .opacity(0.75)
            }
        }
        .padding(padding)
        .background(Color.white)
        .cornerRadius(padding)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.15), radius: 8)
        .onAppear {
            countdownTimer.start()
        }
    }
}

// MARK: - NativeContentView_Previews

#Preview {
    NativeAdCardView()
}
