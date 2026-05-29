import sys

with open('lib/features/my_tickets/presentation/views/widgets/boarding_pass_sheet.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("import 'package:pdf/pdf.dart';", "import 'package:transportation_app/core/helper/extensions.dart';\nimport 'package:pdf/pdf.dart';")
content = content.replace("_originCode(t.originGovernorate)", "_originCode(context.isArabic ? (t.originGovernorateAr ?? t.originGovernorate) : t.originGovernorate)")
content = content.replace("_originCode(t.destinationGovernorate)", "_originCode(context.isArabic ? (t.destinationGovernorateAr ?? t.destinationGovernorate) : t.destinationGovernorate)")
content = content.replace("Text(\n                                      t.originGovernorate", "Text(\n                                      context.isArabic ? (t.originGovernorateAr ?? t.originGovernorate) : t.originGovernorate")
content = content.replace("Text(\n                                        t.originStation", "Text(\n                                        context.isArabic ? (t.originStationNameAr ?? t.originStation) : t.originStation")
content = content.replace("Text(\n                                      t.agencyName", "Text(\n                                      context.isArabic ? (t.agencyNameAr ?? t.agencyName) : t.agencyName")
content = content.replace("Text(\n                                      t.destinationGovernorate", "Text(\n                                      context.isArabic ? (t.destinationGovernorateAr ?? t.destinationGovernorate) : t.destinationGovernorate")
content = content.replace("Text(\n                                        t.destinationStation", "Text(\n                                        context.isArabic ? (t.destinationStationNameAr ?? t.destinationStation) : t.destinationStation")

with open('lib/features/my_tickets/presentation/views/widgets/boarding_pass_sheet.dart', 'w', encoding='utf-8') as f:
    f.write(content)
