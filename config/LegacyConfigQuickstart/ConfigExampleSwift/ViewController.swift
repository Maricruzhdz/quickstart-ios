//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import Firebase

@objc(ViewController)
class ViewController: UIViewController {
  let welcomeMessageConfigKey = "welcome_message"
  let welcomeMessageCapsConfigKey = "welcome_message_caps"
  let loadingPhraseConfigKey = "loading_phrase"

  var remoteConfig: RemoteConfig!
  @IBOutlet var welcomeLabel: UILabel!
  @IBOutlet var fetchButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    // [START get_remote_config_instance]
    remoteConfig = RemoteConfig.remoteConfig()
    // [END get_remote_config_instance]

    // Create a Remote Config Setting to enable developer mode, which you can use to increase
    // the number of fetches available per hour during development. See Best Practices in the
    // README for more information.
    // [START enable_dev_mode]
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings
    // [END enable_dev_mode]

    // Set default Remote Config parameter values. An app uses the in-app default values, and
    // when you need to adjust those defaults, you set an updated value for only the values you
    // want to change in the Firebase console. See Best Practices in the README for more
    // information.
    // [START set_default_values]
    remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    // [END set_default_values]

    fetchConfig()
  }

  func fetchConfig() {
    welcomeLabel.text = remoteConfig[loadingPhraseConfigKey].stringValue

    // [START fetch_config_with_callback]
    remoteConfig.fetch { (status, error) -> Void in
      if status == .success {
        print("Config fetched!")
        self.remoteConfig.activate { changed, error in
          // ...
        }
      } else {
        print("Config not fetched")
        print("Error: \(error?.localizedDescription ?? "No error available.")")
      }
      self.displayWelcome()
    }
    // [END fetch_config_with_callback]
  }

  func displayWelcome() {
    // [START get_config_value]
    var welcomeMessage = remoteConfig[welcomeMessageConfigKey].stringValue
    // [END get_config_value]

    if remoteConfig[welcomeMessageCapsConfigKey].boolValue {
      welcomeMessage = welcomeMessage?.uppercased()
    }
    welcomeLabel.text = welcomeMessage
  }

  // Display welcome message in all caps if welcome_message_caps is set to true. Otherwise
  // display welcome message as fetched from welcome_message.
  @IBAction func handleFetchTouch(_ sender: AnyObject) {
    fetchConfig()
  }
}
