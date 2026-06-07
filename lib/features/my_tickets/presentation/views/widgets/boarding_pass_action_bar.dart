import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/passenger_boarding_pass_cubit.dart';

class BoardingPassActionBar extends StatelessWidget {
  final Future<void> Function(String qrPayload) onDownload;
  final Future<void> Function(String qrPayload) onShare;

  const BoardingPassActionBar({
    super.key,
    required this.onDownload,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child:
          BlocBuilder<PassengerBoardingPassCubit, PassengerBoardingPassState>(
            builder: (_, state) {
              final qrPayload = state is PassengerBoardingPassLoaded
                  ? state.qrPayload
                  : null;

              return Row(
                children: [
                  Expanded(
                    child: BoardingPassDownloadButton(
                      enabled: qrPayload != null,
                      onTap: () => onDownload(qrPayload!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  BoardingPassShareButton(
                    enabled: qrPayload != null,
                    onTap: () => onShare(qrPayload!),
                  ),
                ],
              );
            },
          ),
    );
  }
}

class BoardingPassDownloadButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const BoardingPassDownloadButton({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [ColorsManager.accentCyan, Color(0xFF00BFA5)],
                )
              : null,
          color: enabled ? null : Colors.white12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_rounded,
              color: enabled ? Colors.black : Colors.white38,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.downloadPdf,
              style: TextStyle(
                color: enabled ? Colors.black : Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoardingPassShareButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const BoardingPassShareButton({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [Color(0xFF7B2FBE), Color(0xFF4A90D9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: enabled ? null : Colors.white12,
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF7B2FBE).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Icon(
          Icons.share_rounded,
          color: enabled ? Colors.white : Colors.white24,
          size: 20,
        ),
      ),
    );
  }
}
