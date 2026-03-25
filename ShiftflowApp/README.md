# Shiftflow (SwiftUI iOS)

Original SwiftUI implementation of a colorful shift scheduler app with:

- Shift creation (date, start, end)
- Monthly calendar grid with blue/green/orange shift blocks
- Upcoming shift list
- Local notifications before shift start
- Local data persistence using Core Data
- StoreKit 2 premium unlock for unlimited shifts, reminders, and export feature flags

## Structure

- `ShiftflowApp.swift` bootstraps app dependencies.
- `Persistence/` contains Core Data stack and runtime data model.
- `Views/` includes tab navigation, calendar, list, add-shift, and premium screens.
- `Services/NotificationScheduler.swift` manages local notifications.
- `StoreKit/PurchaseManager.swift` manages in-app purchase state.

## Setup notes

1. Create a new iOS SwiftUI App target in Xcode named `ShiftflowApp`.
2. Add all files in this folder to the target.
3. Enable capabilities:
   - In-App Purchase
   - Push Notifications (for local notifications authorization flow UI)
4. Set product id in App Store Connect: `com.shiftflow.premium.unlock`
5. Configure a StoreKit Configuration file for local testing purchases.

## Uniqueness statement

This app uses an original layout and naming system and intentionally avoids copying any specific third-party shift scheduling app UI/branding.
