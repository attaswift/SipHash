# Version 1.1.1 (2017-02-07)

This release contains the following change:

* A Swift 3.1 compilation issue about SipHash's (ab)use of @inline(__always) was fixed.

# Version 1.1.0 (2016-11-23)

This release contains the following changes:

* `SipHasher` now supports appending optional values directly.
* The deployment target for Carthage and standalone builds was set back to iOS 8.0 and macOS 10.9,
  the earliest possible OS versions for Swift frameworks. This change does not affect CocoaPod builds, which 
  already had the same settings.

# Version 1.0.0 (2016-11-15)

This is the initial release of SipHash.
