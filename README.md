# Rehla Transportation App - Features Documentation

Rehla is a Flutter mobile application for planning trips, booking seats, managing tickets, using wallet payments, receiving real-time travel alerts, and reselling eligible tickets through a marketplace.

<p align="center">
  <img width="180" alt="Travel Smart Logo" src="https://github.com/user-attachments/assets/09be3720-4e44-40b3-9187-6ede0e1428fc" />
</p>

---

## Main User Features

### 1. Onboarding and Startup Flow

The onboarding flow introduces first-time users to the app before they reach authentication. The app stores onboarding completion locally, so returning users are not forced to repeat it. On startup, the app also checks whether saved tokens are still available and chooses the correct initial route.


<p align="center">
<img width="200" alt="Screenshot_1778294432" src="https://github.com/user-attachments/assets/c63cd45d-9235-4241-bb02-7daaba8adcb2" />
<img width="200" alt="Screenshot_1778294430" src="https://github.com/user-attachments/assets/d8b7329f-cfe5-48a0-a7fd-57d6ade1895b" />
<img width="200" alt="Screenshot_1778294437" src="https://github.com/user-attachments/assets/acdfc659-7b95-4f54-bb48-fe194f7595ae" />
</p>


**Feature details**

- Shows onboarding for first-time users.
- Stores onboarding completion locally so returning users skip it.
- Checks saved authentication tokens on startup.
- Routes authenticated users directly to the home screen.
- Routes unauthenticated users to login after onboarding.

### 2. Authentication

Authentication covers registration, login, password recovery, secure session storage, and logout. Protected API requests automatically receive the JWT access token, and expired sessions are handled through silent refresh.

<table align="center">
  <tr>
    <td align="center">
      <img width="200" alt="Screenshot_1778294401-portrait" src="https://github.com/user-attachments/assets/b9c50027-9de5-4730-9eba-03bf1e7893fd" />
      <br/>
      <b>Login</b>
    </td>
    <td align="center">
      <img width="200" alt="Screenshot_1778294409-portrait" src="https://github.com/user-attachments/assets/a48ef21c-5c4d-415d-baa5-a274cf43ceb0" />
      <br/>
      <b>Sign up</b>
    </td>
    <td align="center">
      <img width="250" alt="Screenshot_1780268625-portrait" src="https://github.com/user-attachments/assets/6bcc268b-e0ce-43d1-bd0c-8bd2c0794e80" />
      <br/>
      <b>Forgot password</b>
    </td>
    <td align="center">
      <img width="250" alt="Screenshot_1780268641-portrait" src="https://github.com/user-attachments/assets/64160c47-6982-4467-9f78-4869e0913ea5" />
      <br/>
      <b>Email Sent</b>
    </td>
  </tr>
</table>

**Feature details**

- User registration with personal, contact, gender, date of birth, country, and identity fields.
- Login with email and password.
- Forgot password and reset password flow.
- Secure token storage using `flutter_secure_storage`.
- Automatic JWT attachment to protected API requests.
- Silent token refresh when the access token expires.
- Forced logout when the refresh token is invalid or expired.
- Logout revokes the active refresh token and clears local session data.

### 3. Home Screen and Journey Planning

The home screen is the main entry point for planning a trip. It loads station data, displays popular routes, keeps recent searches, and lets the user prepare a one-way or round-trip search.

**Screenshot placeholder**

![Home and journey planning placeholder](docs/screenshots/home.png)

**Feature details**

- Bottom navigation with Home, Tickets, and Profile tabs.
- Home screen loads station data from the backend.
- Popular routes section.
- Recent searches section backed by local Hive storage.
- Pull-to-refresh behavior for station data.
- Loading shimmer and retry UI for network failures.
- Journey search supports origin, destination, travel date, passenger count, one-way trips, round trips, transport type, and route preferences.

### 4. Search Results

The search feature displays available direct trips and can also search for indirect routes. Results support pagination, filters, and deduplication to keep the list stable while the user scrolls.

**Screenshot placeholders**

![Direct search results placeholder](docs/screenshots/search-results.png)

![Search filters placeholder](docs/screenshots/search-filters.png)

![Indirect search results placeholder](docs/screenshots/indirect-search-results.png)

**Feature details**

- Direct trip search.
- Indirect trip search for routes requiring more than one leg.
- Server-side pagination with "load more" behavior.
- Duplicate result protection when loading additional pages.
- Filters for transport type, sorting, maximum price, preferred agencies, departure time range, and arrival time range.
- Time filters can run client-side without always forcing a new API query.
- Recent searches are saved automatically after a search.

### 5. Seat Selection

Seat selection shows the latest seat map for the chosen trip and class. The UI distinguishes available, pending, and booked seats so users understand what can still be selected.

**Screenshot placeholder**

![Seat selection placeholder](docs/screenshots/seat-selection.png)

**Feature details**

- Real-time seat map loading by trip occurrence.
- Seat classes are loaded from the trip result.
- Seat states include available, pending / temporarily held, and booked.
- Pending seats include hold expiration data from the backend.
- Separate seat-selection flow for normal, indirect, round-trip, and multi-destination bookings.
- Clear error state when the selected class is not available in the seat map.

### 6. Passenger Details

Passenger forms collect the required traveler and contact data before a booking is added to the cart or purchased immediately. The app can autofill data from the authenticated user's profile.

**Screenshot placeholder**

![Passenger details placeholder](docs/screenshots/passenger-details.png)

**Feature details**

- Passenger data forms for selected seats.
- Autofill support from the authenticated user's profile.
- Contact information collection for name, phone, and email.
- Separate passenger forms for direct bookings, indirect bookings, round-trip bookings, multi-destination bookings, and marketplace purchases.

### 7. Booking and Cart

The cart holds pending bookings before checkout. Users can add trips to cart, buy immediately, cancel pending holds, redeem points, and complete checkout using wallet balance.

**Screenshot placeholders**

![Cart screen placeholder](docs/screenshots/cart.png)

![Checkout summary placeholder](docs/screenshots/checkout.png)

**Feature details**

- Add trips to cart.
- Book now flow that adds to cart and immediately checks out.
- Cart contains pending booking holds.
- Each cart item can have a hold expiration time.
- Local notification/alarm is scheduled for cart hold expiry.
- Local cart expiry alarm is canceled after successful checkout.
- Cancel pending cart item / booking hold.
- Cart empty, loading, success, and error states.
- Wallet checkout and loyalty points redemption.
- Checkout error handling for insufficient wallet balance, expired cart, seat conflicts, and validation errors.

### 8. Round-Trip Booking

Round-trip booking guides the user through selecting an outbound trip, automatically searching return trips in the opposite direction, selecting seats for both legs, and submitting both bookings together.

**Screenshot placeholders**

![Round-trip outbound placeholder](docs/screenshots/round-trip-outbound.png)

![Round-trip return placeholder](docs/screenshots/round-trip-return.png)

![Round-trip summary placeholder](docs/screenshots/round-trip-summary.png)

**Feature details**

- Search outbound trip.
- Select outbound trip and class.
- Automatically search return trips using swapped origin and destination.
- Select return trip and class.
- Select seats for both legs.
- Add both legs to cart.
- Book both legs immediately.
- Supports pagination and filters for outbound and return trips.
- Preserves partial state if one leg succeeds and another leg fails, so the user receives a meaningful error instead of losing context.

### 9. Indirect Booking

Indirect booking supports routes that cannot be completed with a single direct trip. The app lets users choose a composed route and continue through passenger details and checkout using the same booking infrastructure.

**Screenshot placeholders**

![Indirect booking placeholder](docs/screenshots/indirect-booking.png)

![Indirect passenger form placeholder](docs/screenshots/indirect-passenger-form.png)

**Feature details**

- Search indirect route options.
- Select trips that compose the route.
- Fill passenger details for the full indirect route.
- Add indirect trip selections to cart.
- Continue checkout through the same booking/cart system.

### 10. Multi-Destination Booking

Multi-destination booking lets users build a trip made of multiple legs. Each leg is searched, selected, seated, and submitted as part of one flow.

**Screenshot placeholders**

![Multi-destination builder placeholder](docs/screenshots/multi-destination-builder.png)

![Multi-destination summary placeholder](docs/screenshots/multi-destination-summary.png)

![Multi-destination booking placeholder](docs/screenshots/multi-destination-booking.png)

**Feature details**

- Build a journey with multiple destination legs.
- Review a multi-leg summary.
- Search trips leg by leg.
- Select trip and class for each leg.
- Select seats for each leg.
- Add all legs to cart.
- Book all legs immediately with optional points redemption.
- Step-based flow allows the user to go backward between leg search, seat selection, and summary.

### 11. My Tickets

The tickets area gives users access to their active and historical bookings. Users can view ticket details, refresh the list, request refunds, and move eligible tickets into the resale flow.

**Screenshot placeholders**

![My tickets placeholder](docs/screenshots/my-tickets.png)

![Ticket details placeholder](docs/screenshots/ticket-details.png)

**Feature details**

- Displays authenticated user's tickets.
- Ticket list refresh.
- Ticket details screen.
- Upcoming ticket detection based on boarding time and confirmed status.
- Passenger and seat details.
- Refund request flow.
- Cached ticket list prevents the UI from being cleared during intermediate marketplace actions.

### 12. Boarding Pass

Confirmed tickets can show a boarding pass with passenger and route details. The app retrieves a signed QR payload from the backend and can render or export the boarding pass.

**Screenshot placeholders**

![Boarding pass placeholder](docs/screenshots/boarding-pass.png)

![Boarding pass PDF placeholder](docs/screenshots/boarding-pass-pdf.png)

**Feature details**

- Boarding pass sheet for confirmed tickets.
- Passenger, route, and ticket details.
- QR payload retrieval from the backend.
- QR code rendering using `qr_flutter`.
- PDF generation and printing/sharing support using `pdf` and `printing`.
- Backend contract uses signed QR payloads for verification.

### 13. Ticket Marketplace

The marketplace allows users to resell eligible tickets and buy listed tickets from other users. The purchase flow collects new passenger data while preserving the original seat assignment.

**Screenshot placeholders**

![Marketplace placeholder](docs/screenshots/marketplace.png)

![Resell tickets placeholder](docs/screenshots/resell-tickets.png)

![Marketplace purchase placeholder](docs/screenshots/marketplace-purchase.png)

**Feature details**

- List eligible tickets for resale.
- Cancel an active listing.
- Browse active marketplace listings.
- Filter listings by origin governorate, destination governorate, and travel date.
- Buy a marketplace ticket by entering passenger details.
- Hides the current user's own listings from the marketplace list when seller ID is available.
- Marketplace purchase preserves the original seat assignment.
- Prevents reselling tickets that were already purchased from the marketplace, based on backend rules.

### 14. Wallet

The wallet is used for deposits, ticket checkout, refunds, and transaction history. Wallet state is cached where needed so the UI remains readable during refreshes.

**Screenshot placeholders**

![Wallet section placeholder](docs/screenshots/wallet.png)

![Wallet deposit placeholder](docs/screenshots/wallet-deposit.png)

![Wallet history placeholder](docs/screenshots/wallet-history.png)

**Feature details**

- Wallet balance display.
- Deposit to wallet by card-like payment form.
- Wallet transaction history.
- Wallet payment during checkout.
- Wallet refund support through refund request processing.
- Cached wallet balance keeps the UI stable while new data is loading.

### 15. Loyalty and Rewards

The loyalty feature displays the user's points balance, point history, active challenges, and reward progress. Points can also be redeemed during checkout.

**Screenshot placeholders**

![Loyalty hub placeholder](docs/screenshots/loyalty-hub.png)

![Loyalty history placeholder](docs/screenshots/loyalty-history.png)

**Feature details**

- Profile displays loyalty points balance.
- Loyalty hub screen.
- Point history ledger.
- Challenge history.
- Active challenges from profile data.
- Points redemption during checkout.
- Backend contract supports earned, redeemed, pending, and expired point transactions.

### 16. Profile Management

The profile area centralizes account information, profile updates, picture upload, wallet access, language preference, and logout.

**Screenshot placeholders**

![Profile placeholder](docs/screenshots/profile.png)

![Edit profile placeholder](docs/screenshots/edit-profile.png)

**Feature details**

- View authenticated user profile.
- Edit profile information.
- Upload profile picture using `image_picker`.
- View wallet data from profile.
- Change preferred language.
- Logout.
- Profile screen integrates quick actions for wallet, loyalty, notifications, support, and other account features.

### 17. Notifications

Notifications combine an in-app inbox, real-time SignalR delivery, Firebase push notifications, and local device notifications. The backend can localize push notification content based on the user's selected language.

**Screenshot placeholders**

![Notifications inbox placeholder](docs/screenshots/notifications.png)

![Notification permission placeholder](docs/screenshots/notification-permission.png)

**Feature details**

- Firebase Cloud Messaging initialization.
- Local notifications initialization.
- Notification permission gate.
- SignalR service for real-time notifications.
- Notification inbox.
- Mark one notification as read.
- Mark all notifications as read.
- Delete notification.
- Backend supports localized push notifications based on preferred language.
- Boarding-soon alerts are supported by the backend contract.

### 18. Support and Issue Reporting

Support screens let users submit issues and review previous tickets. This gives the app a direct feedback and assistance channel.

**Screenshot placeholders**

![Report issue placeholder](docs/screenshots/report-issue.png)

![Support tickets placeholder](docs/screenshots/support-tickets.png)

**Feature details**

- Report issue screen.
- Submit support ticket.
- Support ticket history screen.
- Refresh support ticket list.
- Loading, success, empty, and error states.

### 19. Localization

The app supports English and Arabic through Flutter localization files and a shared locale cubit. The selected language can also be synchronized with the backend for localized notifications.

**Screenshot placeholders**

![English localization placeholder](docs/screenshots/localization-en.png)

![Arabic localization placeholder](docs/screenshots/localization-ar.png)

**Feature details**

- English and Arabic localization files.
- App-wide `LocaleCubit`.
- Saved locale preference using Hive.
- Server-side language preference update for localized notifications.
- Material localization delegates enabled.

### 20. UI and UX

The app uses shared themed widgets and a custom bottom navigation layout to keep the interface consistent across all flows.

**Screenshot placeholders**

![Navigation placeholder](docs/screenshots/navigation.png)

![Reusable components placeholder](docs/screenshots/ui-components.png)

**Feature details**

- Custom bottom navigation.
- Reusable themed widgets such as gradient buttons, text fields, containers, shimmer loading views, profile picture picker, and language toggle button.
- Poppins font family.
- Responsive font helper.
- Consistent dark transportation-style theme.
- Error localizer for user-facing API/network errors.

---

## Technical Architecture

### Project Structure

The project follows a feature-first clean architecture style:

- `lib/core`: shared routing, networking, dependency injection, localization, notifications, theming, utilities, widgets, and error types.
- `lib/features`: application features split into data, domain, and presentation layers where applicable.
- `data`: remote/local data sources, models, and repository implementations.
- `domain`: entities, repositories, and use cases.
- `presentation`: screens, widgets, cubits, and states.

### State Management

- Uses `flutter_bloc` Cubit classes for feature state.
- Uses explicit loading, loaded, error, success, and action-specific states.
- Checks `isClosed` before emitting after asynchronous operations to avoid emitting into disposed cubits.

### Dependency Injection

- Uses `get_it`.
- Dependencies are registered in `lib/core/di/injection_container.dart`.
- Use cases depend on repositories.
- Repositories depend on data sources.
- Cubits receive use cases through dependency injection.

### Networking

- Uses `dio`.
- Shared API constants are defined in `lib/core/constants/api_constants.dart`.
- JWT authentication is handled through an auth interceptor.
- API failures are converted into failure objects and surfaced to the UI.

### Local Storage

- Uses Hive for recent searches and locale data.
- Uses secure storage for authentication tokens.
- Uses shared preferences for onboarding state.

### Notifications

- Uses Firebase Messaging for push notifications.
- Uses local notifications for device alerts.
- Uses SignalR for live in-app notification delivery.
- Uses local alarm scheduling for cart hold expiration reminders.

---

## Problems Solved

### 1. Token Refresh Race Condition

**Problem:**  
When the access token expires, multiple API requests can fail with `401` at the same time. Without coordination, every failed request may call the refresh endpoint separately. That can rotate the refresh token multiple times, causing later refresh attempts to use an already-invalid token and forcing the user to logout unexpectedly.

**Solution in the app:**  
`AuthInterceptor` stores a shared `_refreshFuture`. If a refresh is already running, all other failed requests await the same future instead of starting another refresh call.

After the refresh succeeds:

- The new access and refresh tokens are saved.
- The original failed request is retried once.
- A request flag prevents infinite retry loops.

If the refresh token is invalid:

- Tokens are cleared.
- SignalR is disconnected.
- The user is redirected to the login screen.

This keeps the session stable even when several protected requests fail at the same time.

### 2. Seat Booking Race Condition

**Problem:**  
Two users can try to book the same seat at nearly the same time. The UI may show the seat as available for both users if their seat maps were loaded before either user completed booking.

**Solution in the app and backend contract:**  
The backend provides real-time seat states and a cart hold system:

- Seats can be `Available`, `Pending`, or `Booked`.
- Adding to cart creates a temporary hold.
- Holds expire after a fixed time window.
- If a seat is taken by another user, the API returns a conflict such as `SEAT_ALREADY_BOOKED`.

The app handles this by:

- Loading the latest seat map before seat selection.
- Showing pending/booked seats distinctly.
- Surfacing seat conflict errors to the user.
- Refreshing cart state after cancellation or checkout actions.
- Scheduling a local hold-expiry reminder so users know when pending cart seats will be released.

### 3. Expired Cart Holds

**Problem:**  
Users may leave the cart open while the backend hold expires. Checkout would then fail because seats are no longer reserved.

**Solution:**  
Cart items include `holdExpiresAt`. The app schedules local expiry notifications and cancels them after checkout. When the cart is fetched again, expired or missing cart data is represented as an empty cart or an error state instead of allowing silent failure.

### 4. Async UI State After Navigation

**Problem:**  
Network requests may finish after the user leaves a screen. Emitting state after a Cubit is closed can cause runtime errors.

**Solution:**  
Cubits check `isClosed` before emitting state after asynchronous operations. This pattern appears across booking, search, profile, marketplace, support, and ticket flows.

### 5. Pagination Duplicates

**Problem:**  
Paginated APIs can return overlapping results across pages, especially when data changes while the user scrolls.

**Solution:**  
Search, round-trip, and multi-destination flows deduplicate loaded results by trip occurrence IDs before appending new items.

### 6. UI Flicker During Intermediate Actions

**Problem:**  
Actions such as listing a ticket on the marketplace or refreshing wallet data can temporarily replace loaded screen data with loading states, making the UI feel unstable.

**Solution:**  
The ticket and wallet cubits keep cached copies of the last successful data. The UI can continue showing meaningful information while intermediate actions run.

---

## Main Technologies

- Flutter
- Dart
- flutter_bloc
- dio
- get_it
- dartz
- Hive / Hive Flutter
- flutter_secure_storage
- Firebase Core
- Firebase Messaging
- flutter_local_notifications
- SignalR
- qr_flutter
- pdf / printing
- image_picker
- intl
- shimmer
- fl_chart
