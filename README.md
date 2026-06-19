# Rihla Transportation App - Features Documentation

Rihla is a Flutter mobile application for planning trips, booking seats, managing tickets, using wallet payments, receiving real-time travel alerts, and reselling eligible tickets through a marketplace.

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
      <img width="200" alt="Screenshot_1781184871-portrait" src="https://github.com/user-attachments/assets/aaf02b14-a5d4-4fcb-b378-1bb9d340dddd" />
      <br/>
      <b>Forgot password</b>
    </td>
    <td align="center">
      <img width="200" alt="Screenshot_1781184875-portrait" src="https://github.com/user-attachments/assets/b170931e-5560-4bef-9961-ad6eb3f375e8" />
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

<p align = "center">
  <img width="200" alt="Screenshot_1781184271-portrait" src="https://github.com/user-attachments/assets/53393b19-c23a-4fda-ab9e-d56294d3a81d" />
<p/>
  
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

<table align="center">
  <tr>
    <td align="center">
      <img width="200" alt="Screenshot_1781184312-portrait" src="https://github.com/user-attachments/assets/ed1ecc25-c38d-4aba-9d1f-cd7980170637" />
      <br/>
      <b>Direct Search Results</b>
    </td>
    <td align="center">
      <img width="200" alt="Screenshot_1781184317-portrait" src="https://github.com/user-attachments/assets/4b5fd73e-66de-4a99-be2d-3d228241c845" />
      <br/>
      <b>Search Filters</b>
    </td>
    <td align="center">
      <img width="200" alt="Screenshot_1781184380-portrait" src="https://github.com/user-attachments/assets/79dbbcea-472d-4466-a7ec-5f6e1bb0e62d" />
      <br/>
      <b>Indirect Search Results</b>
    </td>
  </tr>
</table>

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

<p align="center">
  <img width="200" alt="Screenshot_1781184437-portrait" src="https://github.com/user-attachments/assets/9c025c46-10ef-43c9-8bf4-fc68ae262135" />
</p>

**Feature details**

- Real-time seat map loading by trip occurrence.
- Seat classes are loaded from the trip result.
- Seat states include available, pending / temporarily held, and booked.
- Pending seats include hold expiration data from the backend.
- Separate seat-selection flow for normal, indirect, round-trip, and multi-destination bookings.
- Clear error state when the selected class is not available in the seat map.

### 6. Passenger Details

Passenger forms collect the required traveler and contact data before a booking is added to the cart or purchased immediately. The app can autofill data from the authenticated user's profile.

<p align = "center">
<img width="200" alt="Screenshot_1781184463-portrait" src="https://github.com/user-attachments/assets/ce6e5265-22f2-4cf7-8f91-56ccfdc1ce98" />
</p>

**Feature details**

- Passenger data forms for selected seats.
- Autofill support from the authenticated user's profile.
- Contact information collection for name, phone, and email.
- Separate passenger forms for direct bookings, indirect bookings, round-trip bookings, multi-destination bookings, and marketplace purchases.

### 7. Booking and Cart

The cart holds pending bookings before checkout. Users can add trips to cart, buy immediately, cancel pending holds, redeem points, and complete checkout using wallet balance.

<p align="center">
  <img width="200" alt="Screenshot_1781184485-portrait" src="https://github.com/user-attachments/assets/a04aa5ad-2019-4c34-80bc-2924ca3cbc6e" />
  <img width="200" alt="Screenshot_1781184488-portrait" src="https://github.com/user-attachments/assets/2886bd26-bf1d-42c4-bce7-5db96d5a359d" />
</p>

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

<p align="center">
<img width="200" alt="Screenshot_1781190489-portrait" src="https://github.com/user-attachments/assets/1144b303-c0e7-48b3-835d-7dfe3859b17a" />
<img width="200" alt="Screenshot_1781190510-portrait" src="https://github.com/user-attachments/assets/ab6a4140-f032-4f04-8b30-e36daa59f8bf" />
<img width="200" alt="Screenshot_1781190498-portrait" src="https://github.com/user-attachments/assets/f29815d2-e5e9-4491-a250-5131a0cde0f3" />
</p>

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

<p align="center">
<img width="200" alt="Screenshot_1780648769-portrait" src="https://github.com/user-attachments/assets/273214ee-f76b-430f-aa56-85c633cdb012" />
<img width="200" alt="Screenshot_1780648808-portrait" src="https://github.com/user-attachments/assets/4b8c040a-90d6-462b-ab0c-ad9a984bad07" />

</p>

**Feature details**

- Search indirect route options.
- Select trips that compose the route.
- Fill passenger details for the full indirect route.
- Add indirect trip selections to cart.
- Continue checkout through the same booking/cart system.

### 10. Multi-Destination Booking

Multi-destination booking lets users build a trip made of multiple legs. Each leg is searched, selected, seated, and submitted as part of one flow.

<p align="center">
<img width="200" alt="Screenshot_1780607150-portrait" src="https://github.com/user-attachments/assets/eb725ed2-1e15-4f0e-a5af-a2e6d0933c9b" />
<img width="200"  alt="Screenshot_1780643347-portrait" src="https://github.com/user-attachments/assets/85cbd042-5f4f-4f6e-9a69-7b4e5fedc831" />
</p>

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

<p align="center">
  <img width="200" alt="Screenshot_1780642109-portrait" src="https://github.com/user-attachments/assets/1c9aea1c-a3de-4ea7-9da6-c6ac55913c86" />
  <img width="200" alt="Screenshot_1780642117-portrait" src="https://github.com/user-attachments/assets/715b5bea-4f67-4c81-85d0-0b7fcd3de5cd" />
</p>

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

<p align="center">
 <img width="200" alt="Screenshot_1780643509-portrait" src="https://github.com/user-attachments/assets/682427fa-e1be-493a-a5cd-71e7779869b5" />
  <img width="200" alt="Screenshot_1780643650-portrait" src="https://github.com/user-attachments/assets/c18cc32f-a1a8-4573-924d-2adae61756dd" />
</p>

**Feature details**

- Boarding pass sheet for confirmed tickets.
- Passenger, route, and ticket details.
- QR payload retrieval from the backend.
- QR code rendering using `qr_flutter`.
- PDF generation and printing/sharing support using `pdf` and `printing`.
- Backend contract uses signed QR payloads for verification.

### 13. Ticket Marketplace

The marketplace allows users to resell eligible tickets and buy listed tickets from other users. The purchase flow collects new passenger data while preserving the original seat assignment.

<p align="center">
  <img width="250" alt="Screenshot_1780642226-portrait" src="https://github.com/user-attachments/assets/98d0e849-4fbd-4380-836c-47211f8bb9b8" />
<img width="250" alt="Screenshot_1780641611-portrait" src="https://github.com/user-attachments/assets/19f2aec4-f098-439a-8122-82a9edfb7733" />
</p>

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

<p align="center">
  <img width="200" alt="Screenshot_1778312030-portrait" src="https://github.com/user-attachments/assets/9ca90e8e-c060-40aa-b945-794dd6ffa6af" />
  <img width="200" alt="Screenshot_1781189088-portrait" src="https://github.com/user-attachments/assets/9daf12bb-4823-4d04-b1ff-ffe2c64efb1d" />
</p>

**Feature details**

- Wallet balance display.
- Deposit to wallet by card-like payment form.
- Wallet transaction history.
- Wallet payment during checkout.
- Wallet refund support through refund request processing.
- Cached wallet balance keeps the UI stable while new data is loading.

### 15. Loyalty and Rewards

The loyalty feature displays the user's points balance, point history, active challenges, and reward progress. Points can also be redeemed during checkout.

<p align="center">
  <img width="200" alt="Screenshot_1778311001-portrait" src="https://github.com/user-attachments/assets/883ebf9e-69c6-4e06-81b8-e28019015898" />
  <img width="200" alt="Screenshot_1778311004-portrait" src="https://github.com/user-attachments/assets/9a52693f-fd9b-4886-88e0-a5dc6261d230" />
  <img width="200" alt="Screenshot_1778311005-portrait" src="https://github.com/user-attachments/assets/cca58d16-b86c-4686-8569-d4d2df8fc054" />
</p>

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

<p align="center">
  <img width="250" alt="Screenshot_1780664547-portrait" src="https://github.com/user-attachments/assets/59580667-0b7e-4139-a3e1-e137ff5d1589" />
  <img width="250" alt="Screenshot_1780667789-portrait" src="https://github.com/user-attachments/assets/16ea7caf-93bb-4842-8829-52b351e7580b" />
</p>

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

<p align="center">
  <img width="200" alt="Screenshot_20260610_194512_One UI Home-portrait" src="https://github.com/user-attachments/assets/f281ca45-45f8-4750-a8a2-9fee1911fb52" />
  <img width="200" alt="Screenshot_1780261989-portrait" src="https://github.com/user-attachments/assets/be1713df-6736-4c17-b1de-b2996eb24ea1" />
  <img width="200" alt="Screenshot_1781189587-portrait" src="https://github.com/user-attachments/assets/4ed8cde9-bf89-4ba7-a811-8efc9b8fa01b" />
</p>

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


<p align="center">
  <img width="200" alt="Screenshot_1781187151-portrait" src="https://github.com/user-attachments/assets/19b146d3-c22c-4297-936d-482af38d4760" />
  <img width="200" alt="Screenshot_1781187149-portrait" src="https://github.com/user-attachments/assets/395aa79d-25fc-4179-93fc-0644fdcbe5aa" />
</p>

**Feature details**

- Report issue screen.
- Submit support ticket.
- Support ticket history screen.
- Refresh support ticket list.
- Loading, success, empty, and error states.

### 19. Localization

The app supports English and Arabic through Flutter localization files and a shared locale cubit. The selected language can also be synchronized with the backend for localized notifications.

<p align="center">
  <img width="200" alt="Screenshot_1780138639-portrait" src="https://github.com/user-attachments/assets/42be8f48-c253-43f0-9dbf-4357fabd8593" />
  <img width="200" alt="Screenshot_1776575055-portrait" src="https://github.com/user-attachments/assets/fb97a01d-57e1-4aa5-970d-e1ef49dc9705" />
</p>

**Feature details**

- English and Arabic localization files.
- App-wide `LocaleCubit`.
- Saved locale preference using Hive.
- Server-side language preference update for localized notifications.
- Material localization delegates enabled.

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

---

## Future Work

Although Rihla currently provides a complete prototype for journey planning, booking, wallet checkout, ticket management, notifications, support, and ticket resale, several future improvements can make the platform more production-ready and scalable.

### 1. Official Provider Integration and Fraud Prevention

The current version works as a prototype where booking and ticketing are managed inside Rihla's own system. In a real production environment, Rihla should be officially integrated with transportation providers such as train and bus companies.

With official contracts or provider API integration, every booking made through Rihla would also be registered in the provider's official database. This would help prevent fraud cases such as fake tickets, duplicated seats, or tickets that are valid inside Rihla but not recognized by the real transport operator.

**Future goal:** move from prototype-controlled booking to provider-authorized booking.

**Possible improvements:**

- Official contracts with transportation providers.
- Direct integration with provider booking APIs.
- Synchronization between Rihla bookings and provider databases.
- Provider-side ticket confirmation.
- Stronger fraud prevention for fake, duplicated, cancelled, or resold tickets.
- Official seat ownership validation before boarding.

### 2. Real Payment Gateway Integration

The current wallet and deposit flow can be extended with real payment gateway support. In production, Rihla should integrate with trusted payment providers to support real financial transactions.

**Possible improvements:**

- Integrate with Paymob, Fawry, Stripe, or similar payment gateways.
- Support Egyptian wallet payment methods such as Vodafone Cash, Orange Money, and Etisalat Cash.
- Confirm deposits and payments using secure webhook callbacks.
- Credit the user's wallet only after successful payment confirmation.
- Improve transaction auditing and financial reliability.

### 3. Marketplace Price Negotiation

The current marketplace allows eligible tickets to be listed and purchased. A future improvement is to support price negotiation between buyers and sellers instead of only fixed-price resale.

**Possible improvements:**

- Buyers can send price offers for listed tickets.
- Sellers can accept, reject, or counter the offer.
- Wallet escrow can temporarily reserve the buyer's offered amount.
- SignalR and Firebase notifications can update both users instantly.
- Ticket ownership transfers only after payment confirmation.
- Reserved wallet amounts are released automatically if the offer is rejected or expires.

### 4. Advanced Admin and Operator Dashboard

The system can be expanded with a more powerful dashboard for administrators and transport operators. This would help monitor bookings, users, refunds, support tickets, marketplace activity, and operational statistics.

**Possible improvements:**

- Advanced analytics for bookings, revenue, and popular routes.
- Operator-specific dashboards for provider staff.
- Refund and support performance tracking.
- User activity monitoring.
- Marketplace monitoring and dispute handling.
- Trip occupancy and demand reports.

### 5. Phone Number Verification and Two-Factor Authentication

To improve account security, Rihla can add phone number verification and two-factor authentication.

**Possible improvements:**

- OTP verification during registration.
- OTP verification for sensitive actions such as password reset or wallet operations.
- Two-factor authentication for login.
- Stronger protection against fake accounts and unauthorized access.

### 6. Smarter Fraud Detection and Risk Monitoring

After official provider integration is added, Rihla can also include fraud detection logic to monitor suspicious behavior.

**Possible improvements:**

- Detect repeated failed payment attempts.
- Detect unusual ticket resale patterns.
- Detect suspicious refund behavior.
- Flag duplicated passenger identity usage.
- Monitor abnormal booking activity.
- Notify admins about risky transactions.

### 7. Enhanced Real-Time Travel Updates

The notification system can be improved with live operational updates from providers.

**Possible improvements:**

- Real-time trip delay notifications.
- Gate or platform change alerts.
- Boarding countdown reminders.
- Provider-side cancellation alerts.
- Personalized travel updates based on the user's active tickets.

### 8. Improved Route Recommendation

The search engine can be extended to recommend the best trip based on multiple factors instead of only listing available results.

**Possible improvements:**

- Rank trips by price, duration, departure time, comfort, and transfer waiting time.
- Recommend best value, fastest route, and cheapest route.
- Improve indirect route suggestions.
- Add smarter multi-destination optimization.
- Learn from user preferences and recent searches.
