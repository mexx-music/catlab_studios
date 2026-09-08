import 'package:flutter/material.dart';
import 'package:catlab_studios/core/config/beta_access_config.dart';
import 'package:catlab_studios/core/constants/app_colors.dart';
import 'package:catlab_studios/core/utils/link_launcher.dart';

/// Asks a visitor for the Google account they use on their Android device, so
/// they can be added to a Google Play closed test.
///
/// The first version of this flow is deliberately manual: the visitor's own
/// mail client sends the request, we add the address to the tester list by
/// hand, and Play then grants access. Nothing is stored on the site.
///
/// When [BetaAccessConfig] has no destination the form still renders — so the
/// flow can be reviewed — but submission is disabled and labelled as such
/// rather than silently dropping the address.
/// AI-hint: Keep the "not configured" branch honest; a form that pretends to
/// send is worse than one that says it is not live yet.
class BetaAccessDialog extends StatefulWidget {
  const BetaAccessDialog({super.key, required this.appName});

  final String appName;

  static Future<void> show(BuildContext context, String appName) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(180),
      builder: (_) => BetaAccessDialog(appName: appName),
    );
  }

  @override
  State<BetaAccessDialog> createState() => _BetaAccessDialogState();
}

class _BetaAccessDialogState extends State<BetaAccessDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sent = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Deliberately permissive: this only catches obvious typos, since Google is
  /// the real authority on whether an account exists.
  String? _validate(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Please enter your Google account email address.';
    final looksLikeEmail = RegExp(
      r'^[^@\s]+@[^@\s.]+\.[^@\s]+$',
    ).hasMatch(text);
    if (!looksLikeEmail) return 'That does not look like an email address.';
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!BetaAccessConfig.isConfigured) return;
    const address = BetaAccessConfig.requestEmail;

    final entered = _controller.text.trim();

    final subject = '${widget.appName} — Android beta access request';
    final body =
        '${widget.appName} — Android closed test (Google Play)\n\n'
        'Google account to add: $entered\n\n'
        'Sent from catlabstudios.com\n';

    // Built by hand rather than with Uri(queryParameters: ...), which
    // form-encodes spaces as "+". A mailto query is not form data — RFC 6068
    // clients render that plus literally, so the subject would arrive as
    // "Feline+Alarm+—+Android...". encodeComponent gives %20 instead.
    //
    // Only the query is encoded: percent-encoding the recipient would yield
    // "beta%40catlabstudios.com", which several mail clients mishandle.
    final uri = Uri.parse(
      'mailto:$address'
      '?subject=${Uri.encodeComponent(subject)}'
      '&body=${Uri.encodeComponent(body)}',
    );

    await LinkLauncher.open(uri.toString());
    if (mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(140),
                  blurRadius: 40,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: _sent ? _buildSent(context) : _buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final configured = BetaAccessConfig.isConfigured;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.android_rounded,
                color: AppColors.statusInDevelopment,
                size: 22,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Join the Android Beta',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded),
                color: AppColors.textMuted,
                tooltip: 'Close',
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Enter the Google account email address you use on your Android '
            'device to request access to the ${widget.appName} beta.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller,
            validator: _validate,
            enabled: configured,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'you@gmail.com',
              hintStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.accent.withAlpha(180)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!configured) const _NotLiveNotice(),
          if (!configured) const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: configured ? _submit : null,
              icon: const Icon(Icons.mail_outline_rounded, size: 17),
              label: const Text('Request Beta Access'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.background,
                backgroundColor: AppColors.accent,
                disabledForegroundColor: AppColors.textMuted,
                disabledBackgroundColor: AppColors.surfaceVariant,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Your address is used only to add you to the Google Play tester '
            'list. It is not stored on this site.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.statusAvailable,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              'Almost there',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Your mail app should have opened with the request ready to send. '
          'Once we add your account to the tester list, Google Play will give '
          'you access to the closed test.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 22),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            style: TextButton.styleFrom(foregroundColor: AppColors.accent),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shown while no destination address is configured
// ---------------------------------------------------------------------------
class _NotLiveNotice extends StatelessWidget {
  const _NotLiveNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const Text(
        'Beta sign-up is not open yet. In the meantime the app is available '
        'on the App Store.',
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 12.5,
          height: 1.5,
        ),
      ),
    );
  }
}
