# e_commerce_test_project

## Running the App

The project defines two product flavors in `android/app/build.gradle.kts`:

- **Retail Tenant**: `retail_shop` (Targeted for the retail business tenant).
- **Utility Tenant**: `utility_pay` (Targeted for the utility services tenant).

To run a specific tenant, use the following commands:

### Retail Shop
```bash
flutter run --flavor retail_shop
```

### Utility Pay
```bash
flutter run --flavor utility_pay
```

## Building the App

To build an APK for a specific tenant:

```bash
flutter build apk --flavor retail_shop
flutter build apk --flavor utility_pay
```

## Deliverables

The results of the work (e.g., APK files, screenshots, etc.) can be found in the `deliverables` folder.

---
**Note:** I encountered challenges in implementing a universal solution for screen recording detection on Android. For more details, please refer to the comments in `android/app/src/main/kotlin/com/example/e_commerce_test_project/handlers/SecurityHandler.kt` near the `isScreenRecording` method.

