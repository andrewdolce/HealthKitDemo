HealthKitDemo
=============

A short objective-C demo for reading and writing to HealthKit.

This was the code used in the round-table discussion at the Intrepid Pursuits Learnathon, on 9/27/2014. It shows how to request permissions for HealthKit authorization, write quantity samples, observe when data has changed, and fetch data samples.

Please note that this code cannot actually function correctly without having a provisioning profile and certificate that matches the example app's ID, set up by Intrepid. This is because HealthKit functionality requires app entitlements that must match provisioning.

For another example of HealthKit code, we recommend looking into Apple's WWDC example app, Fit, available at https://developer.apple.com/library/ios/samplecode/Fit/Introduction/Intro.html, as well as watching the WWDC 2014 HealthKit video.
