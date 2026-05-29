import json
import os

def update_arb(path, updates):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    data.update(updates)
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

en_updates = {
    "directTrip": "Direct",
    "stopsCount": "{count} Stops",
    "@stopsCount": {"placeholders": {"count": {"type": "String"}}},
    "hideStops": "Hide Stops",
    "showStops": "Show Stops",
    "routeStops": "Route Stops",
    "howManyPassengers": "How many passengers?",
    "perSeat": "per seat",
    "seatsAvailable": "{n} seats available",
    "@seatsAvailable": {"placeholders": {"n": {"type": "String"}}},
    "continueWithNPassengers": "Continue with {n} Passenger(s)",
    "@continueWithNPassengers": {"placeholders": {"n": {"type": "String"}}},
    "useLoyaltyPoints": "\ud83d\udc8e Use Loyalty Points",
    "noPointsYet": "You don't have any points yet. Complete trips to earn points!",
    "pointsCantBeApplied": "Points can't be applied — cart total is too low (10 EGP minimum final price).",
    "needMorePoints": "You need at least 20 pts to redeem (= 1.00 EGP off). You currently have {points} pts. Keep booking to earn more!",
    "@needMorePoints": {"placeholders": {"points": {"type": "String"}}},
    "ptsLabel": "pts",
    "pointsInfo": "\u2139\ufe0f 20 pts = 1.00 EGP",
    "pointsUsed": "Points used",
    "discount": "Discount",
    "remainingAfter": "Remaining after",
    "finalTotal": "Final total",
    "ptsValue": "{n} pts",
    "@ptsValue": {"placeholders": {"n": {"type": "String"}}}
}

ar_updates = {
    "directTrip": "\u0645\u0628\u0627\u0634\u0631",
    "stopsCount": "{count} \u062a\u0648\u0642\u0641",
    "@stopsCount": {"placeholders": {"count": {"type": "String"}}},
    "hideStops": "\u0625\u062e\u0641\u0627\u0621 \u0627\u0644\u0645\u062d\u0637\u0627\u062a",
    "showStops": "\u0639\u0631\u0636 \u0627\u0644\u0645\u062d\u0637\u0627\u062a",
    "routeStops": "\u0645\u062d\u0637\u0627\u062a \u0627\u0644\u0631\u062d\u0644\u0629",
    "howManyPassengers": "\u0643\u0645 \u0639\u062f\u062f \u0627\u0644\u0645\u0633\u0627\u0641\u0631\u064a\u0646\u061f",
    "perSeat": "\u0644\u0643\u0644 \u0645\u0642\u0639\u062f",
    "seatsAvailable": "{n} \u0645\u0642\u0627\u0639\u062f \u0645\u062a\u0627\u062d\u0629",
    "@seatsAvailable": {"placeholders": {"n": {"type": "String"}}},
    "continueWithNPassengers": "\u0645\u062a\u0627\u0628\u0639\u0629 \u0645\u0639 {n} \u0645\u0633\u0627\u0641\u0631",
    "@continueWithNPassengers": {"placeholders": {"n": {"type": "String"}}},
    "useLoyaltyPoints": "\ud83d\udc8e \u0627\u0633\u062a\u062e\u062f\u0645 \u0646\u0642\u0627\u0637 \u0627\u0644\u0648\u0644\u0627\u0621",
    "noPointsYet": "\u0644\u064a\u0633 \u0644\u062f\u064a\u0643 \u0623\u064a \u0646\u0642\u0627\u0637 \u0628\u0639\u062f. \u0623\u0643\u0645\u0644 \u0631\u062d\u0644\u0627\u062a \u0644\u0643\u0633\u0628 \u0627\u0644\u0646\u0642\u0627\u0637!",
    "pointsCantBeApplied": "\u0644\u0627 \u064a\u0645\u0643\u0646 \u062a\u0637\u0628\u064a\u0642 \u0627\u0644\u0646\u0642\u0627\u0637 - \u0625\u062c\u0645\u0627\u0644\u064a \u0627\u0644\u0633\u0644\u0629 \u0645\u0646\u062e\u0641\u0636 \u062c\u062f\u0627\u064b (\u0627\u0644\u062d\u062f \u0627\u0644\u0623\u062f\u0646\u0649 10 \u062c\u0646\u064a\u0647\u0627\u062a).",
    "needMorePoints": "\u062a\u062d\u062a\u0627\u062c \u0625\u0644\u0649 20 \u0646\u0642\u0637\u0629 \u0639\u0644\u0649 \u0627\u0644\u0623\u0642\u0644 \u0644\u0644\u062e\u0635\u0645 (= \u062e\u0635\u0645 1 \u062c\u0646\u064a\u0647). \u0644\u062f\u064a\u0643 \u062d\u0627\u0644\u064a\u0627\u064b {points} \u0646\u0642\u0637\u0629. \u0627\u0633\u062a\u0645\u0631 \u0641\u064a \u0627\u0644\u062d\u062c\u0632 \u0644\u0643\u0633\u0628 \u0627\u0644\u0645\u0632\u064a\u062f!",
    "@needMorePoints": {"placeholders": {"points": {"type": "String"}}},
    "ptsLabel": "\u0646\u0642\u0637\u0629",
    "pointsInfo": "\u2139\ufe0f 20 \u0646\u0642\u0637\u0629 = 1 \u062c\u0646\u064a\u0647",
    "pointsUsed": "\u0627\u0644\u0646\u0642\u0627\u0637 \u0627\u0644\u0645\u0633\u062a\u062e\u062f\u0645\u0629",
    "discount": "\u0627\u0644\u062e\u0635\u0645",
    "remainingAfter": "\u0627\u0644\u0645\u062a\u0628\u0642\u064a \u0628\u0639\u062f \u0627\u0644\u062e\u0635\u0645",
    "finalTotal": "\u0627\u0644\u0625\u062c\u0645\u0627\u0644\u064a \u0627\u0644\u0646\u0647\u0627\u0626\u064a",
    "ptsValue": "{n} \u0646\u0642\u0637\u0629",
    "@ptsValue": {"placeholders": {"n": {"type": "String"}}}
}

update_arb('lib/core/l10n/app_en.arb', en_updates)
update_arb('lib/core/l10n/app_ar.arb', ar_updates)

print("ARB files updated successfully.")
