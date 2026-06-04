
import json

with open('egypt_stations_flat_localized.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

govs = {}
for entry in data:
    gov_en = entry.get('governorate_en','').strip()
    gov_ar = entry.get('governorate_ar','').strip()
    if gov_en:
        govs[gov_en.lower()] = (gov_en, gov_ar)

with open('govs_output.txt', 'w', encoding='utf-8') as out:
    for k,v in sorted(govs.items()):
        out.write(f'{v[0]} -> {v[1]}\n')

print(f"Total governorates: {len(govs)}")
print("Written to govs_output.txt")
