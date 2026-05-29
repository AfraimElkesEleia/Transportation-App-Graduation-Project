import json

# ─── English ───────────────────────────────────────────────
with open('lib/core/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en = json.load(f)

new_en = {
  'passengerDetails': 'Passenger Details',
  'fullName': 'Full Name',
  'nationalId': 'National ID',
  'emailOptional': 'Email Address (Optional)',
  'requiredField': 'Required',
  'addToCart': 'Add to Cart',
  'bookNow': 'Book Now',
  'passengerN': 'Passenger {n}',
  '@passengerN': {'placeholders': {'n': {'type': 'String'}}},
  'seatLabel': 'Seat: {n}',
  '@seatLabel': {'placeholders': {'n': {'type': 'String'}}},
  'passengersCount': '{n} Passenger(s)',
  '@passengersCount': {'placeholders': {'n': {'type': 'String'}}},
  'selectSeats': 'Select Seats',
  'selectedSeatsLabel': 'Selected: ',
  'seatsCount': '{n} seats',
  '@seatsCount': {'placeholders': {'n': {'type': 'String'}}},
  'totalLabel': 'Total',
  'continueBtn': 'Continue',
  'noSeatsSelected': 'No seats selected',
  'travellingWithFamily': 'Travelling with family?',
  'autoFill': 'Auto-fill',
  'autoFilled': 'Auto-filled \u2714',
  'reFill': 'Re-fill',
  'fillSeat1Info': 'Fill seat 1, then copy name & phone to all other seats.',
  'addEntireJourneyToCart': 'Add Entire Journey to Cart',
  'buildJourney': 'Build Journey',
  'suggestedTransferRoute': 'Suggested Transfer Route',
  'transferAt': 'Transfer at',
  'legN': 'Leg {n}',
  '@legN': {'placeholders': {'n': {'type': 'String'}}},
  'journeyAddedToCart': 'Journey added to cart successfully!',
  'bookingSuccessful': 'Booking successful!',
  'indirectTripAddedToCart': 'Indirect Trip successfully added to Cart!',
  'pleaseSelectSeat': 'Please select a seat',
  'selectExactlyNSeats': 'Please pick exactly {n} seats',
  '@selectExactlyNSeats': {'placeholders': {'n': {'type': 'String'}}},
  'canOnlySelectNSeats': 'You can only select {n} seats for this leg.',
  '@canOnlySelectNSeats': {'placeholders': {'n': {'type': 'String'}}},
  'pleaseSelectNPassengers': 'Please select exactly {n} passengers',
  '@pleaseSelectNPassengers': {'placeholders': {'n': {'type': 'String'}}},
  'fillNamePhoneFirst': 'Please fill in Name and Phone for the first passenger first.',
  'filledNSeats': 'Filled {n} seat(s) with "{name}"',
  '@filledNSeats': {'placeholders': {'n': {'type': 'String'}, 'name': {'type': 'String'}}},
  'requiredCountSeats': 'Required: {n} seats. Selected: {m}',
  '@requiredCountSeats': {'placeholders': {'n': {'type': 'String'}, 'm': {'type': 'String'}}},
}

en.update(new_en)

with open('lib/core/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(en, f, ensure_ascii=False, indent=2)

print('Done EN')

# ─── Arabic ────────────────────────────────────────────────
with open('lib/core/l10n/app_ar.arb', 'r', encoding='utf-8') as f:
    ar = json.load(f)

new_ar = {
  'passengerDetails': '\u0628\u064a\u0627\u0646\u0627\u062a \u0627\u0644\u0645\u0633\u0627\u0641\u0631\u064a\u0646',
  'fullName': '\u0627\u0644\u0627\u0633\u0645 \u0627\u0644\u0643\u0627\u0645\u0644',
  'nationalId': '\u0627\u0644\u0631\u0642\u0645 \u0627\u0644\u0642\u0648\u0645\u064a',
  'emailOptional': '\u0627\u0644\u0628\u0631\u064a\u062f \u0627\u0644\u0625\u0644\u0643\u062a\u0631\u0648\u0646\u064a (\u0627\u062e\u062a\u064a\u0627\u0631\u064a)',
  'requiredField': '\u0645\u0637\u0644\u0648\u0628',
  'addToCart': '\u0623\u0636\u0641 \u0625\u0644\u0649 \u0627\u0644\u0633\u0644\u0629',
  'bookNow': '\u0627\u062d\u062c\u0632 \u0627\u0644\u0622\u0646',
  'passengerN': '\u0645\u0633\u0627\u0641\u0631 {n}',
  '@passengerN': {'placeholders': {'n': {'type': 'String'}}},
  'seatLabel': '\u0627\u0644\u0645\u0642\u0639\u062f: {n}',
  '@seatLabel': {'placeholders': {'n': {'type': 'String'}}},
  'passengersCount': '{n} \u0645\u0633\u0627\u0641\u0631',
  '@passengersCount': {'placeholders': {'n': {'type': 'String'}}},
  'selectSeats': '\u0627\u062e\u062a\u0631 \u0627\u0644\u0645\u0642\u0627\u0639\u062f',
  'selectedSeatsLabel': '\u0627\u0644\u0645\u062d\u062f\u062f: ',
  'seatsCount': '{n} \u0645\u0642\u0627\u0639\u062f',
  '@seatsCount': {'placeholders': {'n': {'type': 'String'}}},
  'totalLabel': '\u0627\u0644\u0625\u062c\u0645\u0627\u0644\u064a',
  'continueBtn': '\u0645\u062a\u0627\u0628\u0639\u0629',
  'noSeatsSelected': '\u0644\u0645 \u064a\u062a\u0645 \u0627\u062e\u062a\u064a\u0627\u0631 \u0645\u0642\u0627\u0639\u062f',
  'travellingWithFamily': '\u0647\u0644 \u062a\u0633\u0627\u0641\u0631 \u0645\u0639 \u0627\u0644\u0639\u0627\u0626\u0644\u0629\u061f',
  'autoFill': '\u062a\u0639\u0628\u0626\u0629 \u062a\u0644\u0642\u0627\u0626\u064a\u0629',
  'autoFilled': '\u062a\u0645 \u0627\u0644\u062a\u0639\u0628\u0626\u0629 \u2714',
  'reFill': '\u0625\u0639\u0627\u062f\u0629 \u0627\u0644\u062a\u0639\u0628\u0626\u0629',
  'fillSeat1Info': '\u0623\u0643\u0645\u0644 \u0627\u0644\u0645\u0642\u0639\u062f \u0627\u0644\u0623\u0648\u0644\u060c \u062b\u0645 \u0627\u0646\u0633\u062e \u0627\u0644\u0627\u0633\u0645 \u0648\u0627\u0644\u0647\u0627\u062a\u0641 \u0644\u0644\u0645\u0642\u0627\u0639\u062f \u0627\u0644\u0623\u062e\u0631\u0649.',
  'addEntireJourneyToCart': '\u0623\u0636\u0641 \u0627\u0644\u0631\u062d\u0644\u0629 \u0628\u0627\u0644\u0643\u0627\u0645\u0644 \u0625\u0644\u0649 \u0627\u0644\u0633\u0644\u0629',
  'buildJourney': '\u0627\u0628\u0646\u0650 \u0631\u062d\u0644\u062a\u0643',
  'suggestedTransferRoute': '\u0645\u0633\u0627\u0631 \u0627\u0644\u062a\u062d\u0648\u064a\u0644 \u0627\u0644\u0645\u0642\u062a\u0631\u062d',
  'transferAt': '\u062a\u062d\u0648\u064a\u0644 \u0641\u064a',
  'legN': '\u0627\u0644\u062c\u0632\u0621 {n}',
  '@legN': {'placeholders': {'n': {'type': 'String'}}},
  'journeyAddedToCart': '\u062a\u0645\u062a \u0625\u0636\u0627\u0641\u0629 \u0627\u0644\u0631\u062d\u0644\u0629 \u0625\u0644\u0649 \u0627\u0644\u0633\u0644\u0629 \u0628\u0646\u062c\u0627\u062d!',
  'bookingSuccessful': '\u062a\u0645 \u0627\u0644\u062d\u062c\u0632 \u0628\u0646\u062c\u0627\u062d!',
  'indirectTripAddedToCart': '\u062a\u0645\u062a \u0625\u0636\u0627\u0641\u0629 \u0627\u0644\u0631\u062d\u0644\u0629 \u063a\u064a\u0631 \u0627\u0644\u0645\u0628\u0627\u0634\u0631\u0629 \u0625\u0644\u0649 \u0627\u0644\u0633\u0644\u0629 \u0628\u0646\u062c\u0627\u062d!',
  'pleaseSelectSeat': '\u0627\u0644\u0631\u062c\u0627\u0621 \u0627\u062e\u062a\u064a\u0627\u0631 \u0645\u0642\u0639\u062f',
  'selectExactlyNSeats': '\u0627\u0644\u0631\u062c\u0627\u0621 \u0627\u062e\u062a\u064a\u0627\u0631 {n} \u0645\u0642\u0627\u0639\u062f \u0628\u0627\u0644\u0636\u0628\u0637',
  '@selectExactlyNSeats': {'placeholders': {'n': {'type': 'String'}}},
  'canOnlySelectNSeats': '\u064a\u0645\u0643\u0646\u0643 \u0627\u062e\u062a\u064a\u0627\u0631 {n} \u0645\u0642\u0639\u062f \u0641\u0642\u0637 \u0644\u0647\u0630\u0627 \u0627\u0644\u062c\u0632\u0621.',
  '@canOnlySelectNSeats': {'placeholders': {'n': {'type': 'String'}}},
  'pleaseSelectNPassengers': '\u0627\u0644\u0631\u062c\u0627\u0621 \u0627\u062e\u062a\u064a\u0627\u0631 {n} \u0645\u0633\u0627\u0641\u0631\u064a\u0646 \u0628\u0627\u0644\u0636\u0628\u0637',
  '@pleaseSelectNPassengers': {'placeholders': {'n': {'type': 'String'}}},
  'fillNamePhoneFirst': '\u0627\u0644\u0631\u062c\u0627\u0621 \u062a\u0639\u0628\u0626\u0629 \u0627\u0644\u0627\u0633\u0645 \u0648\u0627\u0644\u0647\u0627\u062a\u0641 \u0644\u0644\u0645\u0633\u0627\u0641\u0631 \u0627\u0644\u0623\u0648\u0644 \u0623\u0648\u0644\u0627\u064b.',
  'filledNSeats': '\u062a\u0645\u062a \u062a\u0639\u0628\u0626\u0629 {n} \u0645\u0642\u0639\u062f \u0628\u0640 "{name}"',
  '@filledNSeats': {'placeholders': {'n': {'type': 'String'}, 'name': {'type': 'String'}}},
  'requiredCountSeats': '\u0645\u0637\u0644\u0648\u0628: {n} \u0645\u0642\u0627\u0639\u062f. \u062a\u0645 \u0627\u062e\u062a\u064a\u0627\u0631: {m}',
  '@requiredCountSeats': {'placeholders': {'n': {'type': 'String'}, 'm': {'type': 'String'}}},
}

ar.update(new_ar)

with open('lib/core/l10n/app_ar.arb', 'w', encoding='utf-8') as f:
    json.dump(ar, f, ensure_ascii=False, indent=2)

print('Done AR')
