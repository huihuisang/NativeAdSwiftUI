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

// [START load_ad]
import GoogleMobileAds

class RewardedInterstitialViewModel: NSObject, ObservableObject,
  GADFullScreenContentDelegate
{
  @Published var coins = 0
  private var rewardedInterstitialAd: GADRewardedInterstitialAd?

  func loadAd() async {
    do {
      rewardedInterstitialAd = try await GADRewardedInterstitialAd.load(
        withAdUnitID: "ca-app-pub-3940256099942544/6978759866", request: GADRequest())
      // [START set_the_delegate]
      rewardedInterstitialAd?.fullScreenContentDelegate = self
      // [END set_the_delegate]
    } catch {
      print(
        "Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
    }
  }
  // [END load_ad]

  // [START show_ad]
  func showAd() {
    guard let rewardedInterstitialAd = rewardedInterstitialAd else {
      return print("Ad wasn't ready.")
    }

    rewardedInterstitialAd.present(fromRootViewController: nil) {
      let reward = rewardedInterstitialAd.adReward
      print("Reward amount: \(reward.amount)")
      self.addCoins(reward.amount.intValue)
    }
  }
  // [END show_ad]

  func addCoins(_ amount: Int) {
    coins += amount
  }

  // MARK: - GADFullScreenContentDelegate methods

  // [START ad_events]
  func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
    print("\(#function) called")
  }

  func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
    print("\(#function) called")
  }

  func ad(
    _ ad: GADFullScreenPresentingAd,
    didFailToPresentFullScreenContentWithError error: Error
  ) {
    print("\(#function) called")
  }

  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("\(#function) called")
  }

  func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("\(#function) called")
  }

  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("\(#function) called")
    // Clear the rewarded interstitial ad.
    rewardedInterstitialAd = nil
  }
  // [END ad_events]
}