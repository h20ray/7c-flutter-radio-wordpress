# Deep Link Analysis: WordPress News Application

## Executive Summary

Your Flutter WordPress-based news application currently **lacks comprehensive deep-link implementation**. Internal WordPress links within blog posts open in an in-app webview instead of routing to native app screens. The app has no Universal Links (iOS) or App Links (Android) configuration, and no URL-to-route mapping system.

**Domain**: `www.tujuhcahaya.com` (configured in `AppConfig.url`)

---

## 1. Complete Scenario Map

### 1.1 App → Post → Internal Links → Expected Behavior

**Current Behavior:**
- Internal links in post content open in `InAppWebView` (via `url_launcher` with `LaunchMode.inAppWebView`)
- No routing to native post detail screens
- Links are detected as internal via `_isInternalLink()` but not converted to app routes

**Expected Behavior:**
- Internal WordPress post URLs should:
  1. Parse the URL to extract post ID or slug
  2. Fetch post data if not cached
  3. Navigate to `PostDetailPageView` with the post entity
  4. Fallback to webview only if post cannot be resolved

**Failure Points:**
- No URL parsing logic to extract post ID/slug from WordPress URLs
- No mapping between WordPress permalink structure and app routes
- No deep link package installed (`app_links`, `uni_links`, or `go_router`)
- `_handleLinkTap()` always uses `launchUrl()` instead of routing

**Code Location:**
- `lib/features/wordpress/presentation/pages/post_detail_page_view.dart:236-289`

---

### 1.2 Browser → App Continuity

**Current Behavior:**
- **NOT IMPLEMENTED** - No Universal Links or App Links configured
- Links clicked in Safari/Chrome open in browser, not app

**Expected Behavior:**
- User clicks `https://www.tujuhcahaya.com/2024/01/example-post/` in browser
- iOS: Opens app directly via Universal Links (no banner)
- Android: Opens app directly via App Links (no chooser dialog)

**Failure Points:**
- **iOS**: Missing `Associated Domains` entitlement in `Info.plist`
- **iOS**: Missing `apple-app-site-association` file on server
- **Android**: Missing `intent-filter` with `android.intent.action.VIEW` in `AndroidManifest.xml`
- **Android**: Missing `assetlinks.json` file on server
- No deep link listener in `main.dart` or `AppDelegate.swift`

**Missing Files:**
- `ios/Runner/Runner.entitlements` (for Associated Domains)
- `/.well-known/apple-app-site-association` (on WordPress server)
- `/.well-known/assetlinks.json` (on WordPress server)

---

### 1.3 Share URLs → App Routing

**Current Behavior:**
- Shared URLs (via `SharePlus`) contain WordPress permalinks
- When user taps shared link, it opens in browser (no deep link handling)

**Expected Behavior:**
- Shared URL opens app if installed
- App parses URL and navigates to correct post
- Fallback to browser if app not installed

**Failure Points:**
- No deep link handling for shared URLs
- No URL scheme handler (custom scheme like `tujuhcahaya://post/123`)
- Share functionality only copies link to clipboard, doesn't use app-specific URLs

**Code Location:**
- `lib/features/wordpress/presentation/pages/post_detail_page_view.dart:291-349`

---

### 1.4 Push Notifications → Deep Link Routing

**Current Behavior:**
- `AppConfig.oneSignalId` is empty (no push notification service configured)
- No push notification handler found in codebase

**Expected Behavior:**
- Push notification contains WordPress post URL
- Tapping notification opens app and navigates to post
- Handles both foreground and background notification taps

**Failure Points:**
- No push notification service integration
- No notification payload parsing
- No deep link routing from notification data

---

### 1.5 Third-Party Embedded Links (AMP, Jetpack, CDN URLs)

**Current Behavior:**
- `_isInternalLink()` checks domain matching but has issues:
  - Domain config: `www.tujuhcahaya.com` (missing protocol)
  - May not match CDN subdomains (e.g., `cdn.tujuhcahaya.com`)
  - May not match AMP URLs (e.g., `www.tujuhcahaya.com/amp/post/`)

**Expected Behavior:**
- AMP URLs should route to app post view
- CDN URLs for images should be handled separately
- Jetpack embed URLs should be detected and handled

**Failure Points:**
- Domain matching logic too strict:
  ```dart
  // Current: Only matches exact domain or subdomain
  return host == baseDomain || host.endsWith('.$baseDomain');
  ```
- Doesn't handle:
  - `m.tujuhcahaya.com` (mobile subdomain)
  - `amp.tujuhcahaya.com` (AMP subdomain)
  - `cdn.tujuhcahaya.com` (CDN subdomain)
  - Query parameters that change URL structure

**Code Location:**
- `lib/features/wordpress/presentation/pages/post_detail_page_view.dart:222-234`

---

### 1.6 Query Parameters (utm, ?amp, ?m=1, etc.)

**Current Behavior:**
- Query parameters are preserved in URL but not stripped before routing
- `?amp=1`, `?m=1`, `?utm_source=...` may cause routing failures

**Expected Behavior:**
- Strip tracking parameters before URL matching
- Preserve essential parameters (e.g., `?p=123` for post ID)
- Normalize URLs to canonical form

**Failure Points:**
- No URL normalization before parsing
- Query parameters may interfere with post ID extraction
- WordPress permalink structure not analyzed (plain, day/name, month/name, numeric, etc.)

---

### 1.7 WordPress Multilingual or Subdirectory URLs

**Current Behavior:**
- No handling for:
  - `www.tujuhcahaya.com/en/post/` (WPML subdirectory)
  - `www.tujuhcahaya.com/id/post/` (WPML subdirectory)
  - `www.tujuhcahaya.com/wp-content/...` (media URLs)

**Expected Behavior:**
- Detect language prefix and handle appropriately
- Route to post regardless of language prefix
- Exclude media/static file URLs from routing

**Failure Points:**
- No language detection logic
- No subdirectory handling
- Media URLs may be incorrectly identified as internal links

---

### 1.8 HTTP vs HTTPS and Canonical Issues

**Current Behavior:**
- `AppConfig.url` is `www.tujuhcahaya.com` (no protocol)
- Code assumes HTTPS: `Uri.parse('https://${AppConfig.url}$url')`
- No canonical URL handling

**Expected Behavior:**
- Support both HTTP and HTTPS
- Redirect HTTP to HTTPS
- Use canonical URLs from WordPress for matching

**Failure Points:**
- Hardcoded HTTPS assumption
- No HTTP → HTTPS redirect
- Domain config missing protocol causes potential parsing issues
- WordPress may serve different canonical URLs than what's in post.link

**Code Location:**
- `lib/config/app_config.dart:6`
- `lib/features/wordpress/presentation/pages/post_detail_page_view.dart:241-251`

---

## 2. Root Causes, Detection, and Fixes

### 2.1 Missing Deep Link Package

**Root Cause:**
No deep link handling package installed. App uses `url_launcher` only for external links.

**How to Detect:**
```bash
grep -r "app_links\|uni_links\|go_router" pubspec.yaml
# Returns: No matches
```

**Required Implementation:**
1. Add `app_links: ^6.3.0` to `pubspec.yaml`
2. Initialize in `main.dart`:
   ```dart
   import 'package:app_links/app_links.dart';
   
   final appLinks = AppLinks();
   appLinks.uriLinkStream.listen((uri) {
     // Handle deep link
   });
   ```

**Recommended Optimization:**
- Use `app_links` for both iOS and Android (unified API)
- Handle initial link on app launch
- Handle link stream for app-in-background scenarios

---

### 2.2 Missing iOS Universal Links Configuration

**Root Cause:**
No Associated Domains entitlement configured. iOS doesn't know app can handle `tujuhcahaya.com` URLs.

**How to Detect:**
```bash
# Check for entitlements file
ls ios/Runner/*.entitlements
# Returns: No files

# Check Info.plist for Associated Domains
grep -i "associated" ios/Runner/Info.plist
# Returns: No matches
```

**Required Implementation:**

1. **Create `ios/Runner/Runner.entitlements`:**
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>com.apple.developer.associated-domains</key>
       <array>
           <string>applinks:www.tujuhcahaya.com</string>
           <string>applinks:tujuhcahaya.com</string>
       </array>
   </dict>
   </plist>
   ```

2. **Update `ios/Runner.xcodeproj/project.pbxproj`:**
   - Add entitlements file to build settings
   - Or configure in Xcode: Target → Signing & Capabilities → + Associated Domains

3. **Update `ios/Runner/AppDelegate.swift`:**
   ```swift
   import UIKit
   import Flutter
   
   @main
   @objc class AppDelegate: FlutterAppDelegate {
     override func application(
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
       GeneratedPluginRegistrant.register(with: self)
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
     
     override func application(
       _ app: UIApplication,
       open url: URL,
       options: [UIApplication.OpenURLOptionsKey: Any] = [:]
     ) -> Bool {
       // Handle Universal Links
       return super.application(app, open: url, options: options)
     }
   }
   ```

4. **Create `/.well-known/apple-app-site-association` on WordPress server:**
   ```json
   {
     "applinks": {
       "apps": [],
       "details": [
         {
           "appID": "TEAM_ID.com.tujuhcahaya.tujuhcahayaWprs",
           "paths": [
             "/*",
             "/wp-json/*",
             "!/wp-admin/*",
             "!/wp-content/uploads/*"
           ]
         }
       ]
     }
   }
   ```
   - Must be served with `Content-Type: application/json`
   - Must be accessible via HTTPS
   - No file extension
   - Must return 200 status code

**Recommended Optimization:**
- Test with Apple's validator: https://search.developer.apple.com/appsearch-validation-tool/
- Include both `www` and non-www domains
- Exclude admin and media paths

---

### 2.3 Missing Android App Links Configuration

**Root Cause:**
No intent filters for HTTP/HTTPS URLs in `AndroidManifest.xml`. Android doesn't know app can handle `tujuhcahaya.com` URLs.

**How to Detect:**
```bash
grep -A 10 "intent-filter" android/app/src/main/AndroidManifest.xml
# Only shows MAIN/LAUNCHER, no VIEW action for HTTP/HTTPS
```

**Required Implementation:**

1. **Update `android/app/src/main/AndroidManifest.xml`:**
   ```xml
   <activity
       android:name=".MainActivity"
       android:exported="true"
       android:launchMode="singleTop"
       android:taskAffinity=""
       android:theme="@style/LaunchTheme"
       ...>
       <!-- Existing MAIN/LAUNCHER intent filter -->
       <intent-filter>
           <action android:name="android.intent.action.MAIN"/>
           <category android:name="android.intent.category.LAUNCHER"/>
       </intent-filter>
       
       <!-- NEW: App Links intent filter -->
       <intent-filter android:autoVerify="true">
           <action android:name="android.intent.action.VIEW" />
           <category android:name="android.intent.category.DEFAULT" />
           <category android:name="android.intent.category.BROWSABLE" />
           <data
               android:scheme="https"
               android:host="www.tujuhcahaya.com" />
           <data
               android:scheme="https"
               android:host="tujuhcahaya.com" />
       </intent-filter>
   </activity>
   ```

2. **Create `/.well-known/assetlinks.json` on WordPress server:**
   ```json
   [{
     "relation": ["delegate_permission/common.handle_all_urls"],
     "target": {
       "namespace": "android_app",
       "package_name": "com.tujuhcahaya.tujuhcahayaWprs",
       "sha256_cert_fingerprints": [
         "SHA256_FINGERPRINT_FROM_KEYSTORE"
       ]
     }
   }]
   ```
   - Get SHA256 fingerprint: `keytool -list -v -keystore android/app/keystore.jks`
   - Must be served with `Content-Type: application/json`
   - Must be accessible via HTTPS
   - Must return 200 status code

**Recommended Optimization:**
- Test with: `adb shell pm verify-app-links --re-verify com.tujuhcahaya.tujuhcahayaWprs`
- Include both debug and release fingerprints
- Verify with: https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://www.tujuhcahaya.com&relation=delegate_permission/common.handle_all_urls

---

### 2.4 Missing URL-to-Route Mapping

**Root Cause:**
No logic to convert WordPress URLs to app routes. App only handles routes via `RouteGenerator.onGenerate()` with predefined route names.

**How to Detect:**
```dart
// No function exists to parse WordPress URL and return route
// RouteGenerator only handles: /home, /post_detail, etc.
// No handling for: https://www.tujuhcahaya.com/2024/01/post-slug/
```

**Required Implementation:**

1. **Create URL parser service:**
   ```dart
   // lib/core/services/deep_link_service.dart
   class DeepLinkService {
     static String? extractPostIdFromUrl(String url) {
       // Handle various WordPress permalink structures:
       // - Plain: ?p=123
       // - Day/Name: /2024/01/15/post-slug/
       // - Month/Name: /2024/01/post-slug/
       // - Numeric: /archives/123
       // - Post name: /post-slug/
     }
     
     static Future<PostEntity?> resolvePostFromUrl(String url) {
       // Extract ID/slug, fetch from API, return PostEntity
     }
   }
   ```

2. **Update `_handleLinkTap()` in `post_detail_page_view.dart`:**
   ```dart
   Future<void> _handleLinkTap(...) async {
     final isInternal = _isInternalLink(url);
     if (isInternal) {
       // Try to resolve as app route
       final post = await DeepLinkService.resolvePostFromUrl(url);
       if (post != null) {
         Navigator.pushNamed(
           context,
           AppRoutes.postDetail,
           arguments: post,
         );
         return;
       }
     }
     // Fallback to webview
     await launchUrl(uri, mode: LaunchMode.inAppWebView);
   }
   ```

**Recommended Optimization:**
- Cache resolved posts to avoid API calls
- Support category, author, and archive URLs
- Handle 404s gracefully

---

### 2.5 Domain Configuration Issues

**Root Cause:**
`AppConfig.url` is `www.tujuhcahaya.com` (missing protocol), causing inconsistent URL parsing.

**How to Detect:**
```dart
// lib/config/app_config.dart:6
static const String url = 'www.tujuhcahaya.com'; // Missing https://
```

**Required Implementation:**
```dart
class AppConfig {
  static const String baseUrl = 'https://www.tujuhcahaya.com';
  static const String domain = 'www.tujuhcahaya.com';
  static const List<String> allowedDomains = [
    'www.tujuhcahaya.com',
    'tujuhcahaya.com',
    'm.tujuhcahaya.com', // if mobile subdomain exists
  ];
}
```

**Recommended Optimization:**
- Use environment-based config for dev/staging/prod
- Support both www and non-www
- Handle CDN subdomains separately

---

## 3. Missing System Components

### 3.1 iOS Universal Links
- ❌ `Runner.entitlements` file
- ❌ Associated Domains capability
- ❌ `apple-app-site-association` file on server
- ❌ Deep link handler in `AppDelegate.swift`

### 3.2 Android App Links
- ❌ Intent filters for HTTP/HTTPS in `AndroidManifest.xml`
- ❌ `assetlinks.json` file on server
- ❌ `android:autoVerify="true"` attribute

### 3.3 Flutter App
- ❌ Deep link package (`app_links`)
- ❌ URL parsing service
- ❌ WordPress permalink structure analyzer
- ❌ Deep link listener in `main.dart`
- ❌ URL-to-route mapper

### 3.4 WordPress Server
- ❌ `/.well-known/apple-app-site-association`
- ❌ `/.well-known/assetlinks.json`
- ❌ Proper MIME types for association files
- ❌ HTTPS requirement (if not already)

---

## 4. Final Checklist for Complete Deep Link Coverage

### 4.1 Flutter App Implementation

- [ ] Install `app_links: ^6.3.0` package
- [ ] Create `lib/core/services/deep_link_service.dart`:
  - [ ] URL parser for WordPress permalinks
  - [ ] Post ID/slug extraction
  - [ ] Post resolution from URL
  - [ ] Category/author URL handling
- [ ] Update `main.dart`:
  - [ ] Initialize `AppLinks()`
  - [ ] Listen to `uriLinkStream`
  - [ ] Handle initial link on app launch
  - [ ] Route to appropriate screen
- [ ] Update `lib/features/wordpress/presentation/pages/post_detail_page_view.dart`:
  - [ ] Modify `_handleLinkTap()` to route internal links to app
  - [ ] Fallback to webview only if post cannot be resolved
  - [ ] Improve `_isInternalLink()` to handle subdomains
- [ ] Update `lib/core/routes/route_generator.dart`:
  - [ ] Add route handler for deep link URLs
  - [ ] Support URL-based navigation (e.g., `/post/https://www.tujuhcahaya.com/...`)
- [ ] Fix `lib/config/app_config.dart`:
  - [ ] Add `baseUrl` with protocol
  - [ ] Add `allowedDomains` list
  - [ ] Support environment-based config

### 4.2 iOS Configuration

- [ ] Create `ios/Runner/Runner.entitlements`:
  - [ ] Add `com.apple.developer.associated-domains`
  - [ ] Include `applinks:www.tujuhcahaya.com`
  - [ ] Include `applinks:tujuhcahaya.com`
- [ ] Update `ios/Runner.xcodeproj/project.pbxproj`:
  - [ ] Link entitlements file to target
  - [ ] Or configure in Xcode UI
- [ ] Update `ios/Runner/AppDelegate.swift`:
  - [ ] Handle `application(_:open:options:)` for Universal Links
  - [ ] Forward to Flutter via method channel if needed
- [ ] Test Universal Links:
  - [ ] Use Apple's validation tool
  - [ ] Test on physical device (simulator has limitations)
  - [ ] Verify no "Open in Safari" banner appears

### 4.3 Android Configuration

- [ ] Update `android/app/src/main/AndroidManifest.xml`:
  - [ ] Add intent filter with `android.intent.action.VIEW`
  - [ ] Add `android:autoVerify="true"`
  - [ ] Include both `www.tujuhcahaya.com` and `tujuhcahaya.com`
  - [ ] Support both HTTP and HTTPS (or HTTPS only)
- [ ] Get SHA256 certificate fingerprint:
  - [ ] Debug: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
  - [ ] Release: `keytool -list -v -keystore android/app/keystore.jks -alias your-alias`
- [ ] Test App Links:
  - [ ] `adb shell pm verify-app-links --re-verify com.tujuhcahaya.tujuhcahayaWprs`
  - [ ] `adb shell pm get-app-links com.tujuhcahaya.tujuhcahayaWprs`
  - [ ] Test on physical device

### 4.4 WordPress Server Configuration

- [ ] Create `/.well-known/apple-app-site-association`:
  - [ ] JSON format (no file extension)
  - [ ] Include app ID with team ID
  - [ ] Define path patterns (include/exclude)
  - [ ] Serve with `Content-Type: application/json`
  - [ ] Ensure HTTPS and 200 status
  - [ ] Test: `curl https://www.tujuhcahaya.com/.well-known/apple-app-site-association`
- [ ] Create `/.well-known/assetlinks.json`:
  - [ ] Include package name
  - [ ] Include SHA256 fingerprints (debug + release)
  - [ ] Serve with `Content-Type: application/json`
  - [ ] Ensure HTTPS and 200 status
  - [ ] Test: `curl https://www.tujuhcahaya.com/.well-known/assetlinks.json`
- [ ] WordPress Plugin Enhancement (Optional):
  - [ ] Add REST API endpoint to resolve post by URL
  - [ ] Add canonical URL meta tag support
  - [ ] Add Open Graph tags for better sharing

### 4.5 Testing Scenarios

- [ ] **Internal Link in Post:**
  - [ ] Tap link in post content
  - [ ] Verify app navigates to post detail (not webview)
  - [ ] Verify post data loads correctly
- [ ] **Browser → App:**
  - [ ] Open `https://www.tujuhcahaya.com/post-slug/` in Safari (iOS) or Chrome (Android)
  - [ ] Verify app opens directly (no banner/dialog)
  - [ ] Verify correct post loads
- [ ] **Shared URL:**
  - [ ] Share post URL from app
  - [ ] Open shared URL on another device
  - [ ] Verify app opens if installed, browser if not
- [ ] **Push Notification:**
  - [ ] Send push with post URL
  - [ ] Tap notification
  - [ ] Verify app opens to correct post
- [ ] **Query Parameters:**
  - [ ] Test URLs with `?utm_source=...`, `?amp=1`, `?m=1`
  - [ ] Verify parameters are stripped before routing
- [ ] **Subdomains:**
  - [ ] Test `m.tujuhcahaya.com`, `amp.tujuhcahaya.com`
  - [ ] Verify routing works
- [ ] **HTTP vs HTTPS:**
  - [ ] Test HTTP URLs redirect to HTTPS
  - [ ] Test both protocols work

### 4.6 Edge Cases

- [ ] **404 Posts:**
  - [ ] Handle deleted/moved posts gracefully
  - [ ] Show error message, don't crash
- [ ] **External Links:**
  - [ ] Verify external links still open in browser/webview
  - [ ] Don't attempt app routing for external domains
- [ ] **Media URLs:**
  - [ ] Exclude `/wp-content/uploads/*` from routing
  - [ ] Handle image links appropriately
- [ ] **Admin URLs:**
  - [ ] Exclude `/wp-admin/*` from app links
  - [ ] Always open in browser
- [ ] **App Not Installed:**
  - [ ] Fallback to browser gracefully
  - [ ] Consider Smart App Banners (iOS) or App Install Prompts (Android)

---

## 5. Priority Implementation Order

1. **High Priority:**
   - Install `app_links` package
   - Create URL parsing service
   - Update `_handleLinkTap()` to route internal links
   - Fix domain configuration

2. **Medium Priority:**
   - Configure iOS Universal Links
   - Configure Android App Links
   - Create server association files

3. **Low Priority:**
   - Push notification deep links
   - Advanced URL patterns (multilingual, subdirectories)
   - Query parameter normalization

---

## 6. Additional Recommendations

### 6.1 Use go_router for Advanced Routing

Consider migrating from `RouteGenerator` to `go_router` for:
- Declarative routing
- Built-in deep link support
- URL-based navigation
- Better state management

### 6.2 WordPress REST API Enhancement

Add custom endpoint to resolve posts by URL:
```
GET /wp-json/tujuhcahaya/v1/resolve-url?url=https://www.tujuhcahaya.com/post-slug/
```

### 6.3 Analytics Integration

Track deep link usage:
- Which links are clicked most
- Conversion rate (browser → app)
- Failed routing attempts

### 6.4 Error Handling

Implement comprehensive error handling:
- Network failures when resolving posts
- Invalid URLs
- Missing posts
- Timeout scenarios

---

## Conclusion

Your app currently has **zero deep link infrastructure**. Internal WordPress links open in webviews instead of native screens, and there's no browser-to-app continuity. Implementing the checklist above will provide complete deep link coverage for all scenarios.

**Estimated Implementation Time:**
- Flutter app changes: 2-3 days
- iOS/Android configuration: 1 day
- Server configuration: 1 day
- Testing and debugging: 2-3 days
- **Total: 6-8 days**

