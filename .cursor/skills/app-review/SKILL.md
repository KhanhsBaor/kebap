---
name: app-review
description: Prepare an app for platform review and write the submission text from the code itself. Covers Apple App Store / App Review (App Store Connect review info, guideline 2.1 completeness, privacy policy, Info.plist purpose strings, screenshots, demo account, appeals), Meta App Review (Facebook, Instagram, WhatsApp permissions and Advanced Access), TikTok for Developers app review (products, scopes, demo video), and Google Play Console (data safety form, account deletion, app access, the 12 tester closed test, sensitive permissions). Use whenever someone is submitting or resubmitting for review, says their app was rejected ("Apple rejected my app", "App Store Connect", "guideline 2.1", "Meta rejected my app", "TikTok app review failed", "Play Console rejected my update", "insufficient screencast", "permission not shown being used", "missing purpose string", "placeholder content"), needs a use description for a permission like pages_messaging or instagram_business_manage_messages, needs a screen recording or demo video script, reviewer login instructions, or data safety answers, asks which permissions or scopes they actually need, or is about to add a feature that needs a new permission.
---

# Getting through app review the first time

Reviewers are not trying to reject you. They have a few minutes, a checklist, and no idea what your app does. Almost every rejection comes down to one of three things: asking for a permission the reviewer cannot see being used, a recording that skips a step, or a reviewer who could not get in.

This skill writes the submission from the code, so every claim is something the app really does.

## The method, for every platform

1. **Read the code before writing anything.** List every permission, scope or sensitive API the app actually calls, with the file where each is used. This list is the truth; the developer's memory is not.
2. **Cut what is not used.** Every extra permission is a reason to reject. If something is requested but never called, recommend removing it before submitting.
3. **One story per permission:** who the user is, what they tap, what the app does with the permission, and what the user sees as a result. Plain language, no marketing.
4. **Write the recording script** step by step, starting logged out, so it shows each permission being granted and then used.
5. **Write the reviewer instructions:** how to get in, test account details (as placeholders, never real passwords in files), and exactly where each feature is.
6. **Check the current rules before finalising.** Platforms change their forms often. Fetch the official page linked below and adjust if anything has moved.

Save the result as a markdown file the developer can copy from (default `app-review/<platform>-submission.md`). Tell them to keep it out of a public repository if it will ever contain real test credentials.

## Apple App Store (App Review)

Official overview: https://developer.apple.com/distribute/app-review/

Also use: [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/), [App Review Help](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/), and the current [Apple Developer Program License Agreement](https://developer.apple.com/support/terms/).

Apple reviews apps, updates, bundles, in-app purchases, and in-app events. Over 40% of unresolved issues tie to **guideline 2.1 (App Completeness)** — crashes, placeholders, incomplete review info. Roughly half of submissions are reviewed in under 24 hours and 90% in under 48 hours when the submission is complete.

### Before you submit

- **App Review Information (App Store Connect):** demo account username/password if anything is behind login; special config steps; contact info that works. Hard-to-replicate flows → attach a demo video or hardware notes. Missing this delays or fails review.
- **Only ship a finished build.** Test on devices running the latest OS. No crashes, no placeholder text/images, no “coming soon” screens.
- **Working links:** in-app and metadata links must load. A **privacy policy URL** and a **user support** link with current contact info are required for all apps (2.1, 5.1).
- **Privacy policy (5.1)** must state: what data is collected and how; how it is used; that third parties get equal protection; retention/deletion and how users revoke consent or request deletion.
- **Purpose strings:** every sensitive API referenced in code needs a clear `Info.plist` usage description (camera, photos, location, tracking, notifications-related copy where required, etc.). Vague strings get rejected — say *why* with a concrete example. See [5.1.1(ii) purpose strings](https://developer.apple.com/app-store/review/guidelines/#data-collection-and-storage).
- **Screenshots (2.3):** show the real app in use. Overlays may highlight UX; they must not hide or misrepresent it.
- **Metadata matches the binary:** no promised features that are missing (2.3). UI should be clean and usable per HIG — not a thin website wrapper or link farm (4.2).
- **Regulated / sensitive apps:** banking, financial services, crypto, healthcare, gambling, air travel, and similar must be submitted by the **legal entity** that provides the service (not a random individual). Attach partnership/authorization docs in App Store Connect Attachments; describe them in Review Notes (3, 5.1.1).
- **Kids + ads, medical hardware, third-party IP, licensed services (gaming/VPN/etc.):** provide the documentation Apple lists under incomplete-information / guideline 1.3, 1.4, 4.1, 5.2, 5 — do not submit without it.
- **Avoid:** copycats (4.1), spammy similar apps (4.3), apps with little lasting value or niche-only shells (4.2).

### What to write for the developer

From the code and `Info.plist` / entitlements:

1. List every privacy-sensitive API and its purpose string; flag missing or vague strings.
2. Draft **Review Notes**: who the user is, login path, what to tap to see core value, any non-obvious setup.
3. Draft **demo account** placeholders and a short demo-video script if login or hardware is required.
4. Confirm privacy policy URL, support URL, and App Privacy answers match SDKs actually linked (Firebase, analytics, crash, push, etc.).
5. Confirm screenshots and description do not overclaim.

Default output file: `app-review/apple-submission.md`.

### After an Apple rejection

- Read the rejection in App Store Connect; each cited guideline gets one concrete fix.
- Reply in the App Review conversation before or when resubmitting; say what changed and where to verify.
- **Bug-fix updates:** if Apple finds extra non-legal/safety issues, they may offer to approve now and fix next time — accept only via the ASC message if that tradeoff is intentional.
- **Expedite** only for a critical live bug (include repro steps) or a time-bound event you are directly tied to.
- **Appeal** to the App Review Board only with specific guideline-compliance arguments; one appeal per failed submission; answer info requests first.
- Optional: book a [30-minute App Review appointment](https://developer.apple.com/contact/request/app-review-appointment/) (Webex) for process/guideline questions — not a substitute for fixing 2.1 gaps.

## Meta (Facebook, Instagram, WhatsApp)

Official guide: https://developers.facebook.com/docs/app-review

- **Only request what the recording shows.** Each permission needs its own use description and must appear in the screen recording.
- **The recording** must start logged out, show the full login, show the user granting the permission in Meta's dialog, then show the feature that uses it. Use English for the app's interface where possible, or add captions. Explain any button whose meaning is not obvious. Record at 1080p or better.
- **Descriptions** say what the user does and gets, not what the API does. "A shop owner connects their Page so customers who comment 'price' get the price by private message" beats "we use pages_messaging to send messages".
- **Reviewer access:** give a working test login, or clear steps for creating one. A reviewer who cannot sign in rejects.
- **Business verification** is required for some permissions and for Advanced Access. Check it is done before submitting.
- **Required settings:** privacy policy URL, a data deletion URL or callback, app icon, category. All URLs must load for a logged-out visitor.
- **Webhooks:** apps only receive webhooks for people without a role on the app once the app is Live. If testing works for you but not for a real user, check the app mode first.
- **Instagram has two different APIs.** Instagram Login (permissions start `instagram_business_`) needs no Facebook Page. Facebook Login (Page-based, `instagram_manage_*` and `pages_*`) does. Make sure the requested permissions match the login the code uses.

## TikTok for Developers

Official guide: https://developers.tiktok.com/docs/en/app-review-guidelines

- **Demo video:** at least one, up to five, 50 MB each. It must show the complete flow for every product and scope selected. Anything not shown should be removed from the request.
- **Finished app only.** Beta, test or incomplete versions are generally not approved.
- **Policy pages** (privacy policy and terms) must load and must describe what the app does with TikTok data.
- **Publishing content:** the user must see and approve the caption, privacy level and interaction settings before anything is posted. A one-tap publish with no review screen fails.
- Complete any URL or domain verification the portal asks for before submitting.

## Google Play

Official policy centre: https://support.google.com/googleplay/android-developer

- **Closed testing (personal accounts):** a personal developer account created on or after 13 November 2023 must run a closed test with at least 12 testers, opted in for 14 continuous days, before applying for production. Organisation accounts are exempt. Google also checks the testers really used the app.
- **Account deletion:** if the app lets people create an account, it must offer deletion inside the app and a web page where people can request deletion without reinstalling. The web link goes in the Data safety form. Deactivating is not deleting.
- **Data safety form:** must match what the app and every SDK in it actually collect and share. Read the dependencies, not just your own code: analytics, crash reporting, ads and payment SDKs all collect data.
- **App access:** if anything is behind a login, give reviewers working credentials and steps in App content, App access.
- **Sensitive permissions** (SMS, call log, all files access, background location, installed apps list, accessibility, exact alarms) need a declaration and a real core use. If the manifest has one the app does not need, remove it.
- **Target API level:** new apps and updates must target a recent Android version. Check the current requirement in Play Console before building.
- **Privacy policy URL** is required and must load.

## After a rejection

Read the rejection word for word and map each point to one fix. Reply to the reviewer with what changed and where to see it. Resubmitting the same thing with a longer explanation almost never works; a new recording that shows the missing step almost always does. For Apple, fix the cited guideline in the binary/metadata first, then use the App Store Connect App Review thread (appeal/expedite only when those paths actually apply).
