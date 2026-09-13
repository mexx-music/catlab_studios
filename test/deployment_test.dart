import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the deployment configuration for the apex custom domain.
///
/// The site moved from https://mexx-music.github.io/catlab_studios/ to
/// https://catlabstudios.com/. On a root domain the app is served from "/",
/// so a project-path base-href would make every JS, WASM, font and image
/// request 404 — a failure that only shows up in production. These tests are
/// cheap insurance against that regressing.
void main() {
  final workflow = File('.github/workflows/deploy.yml');
  final manifest = File('web/manifest.json');
  final cname = File('web/CNAME');

  group('GitHub Pages deployment', () {
    test('web build uses the root base-href', () {
      final text = workflow.readAsStringSync();
      expect(
        text.contains('--base-href /catlab_studios/'),
        isFalse,
        reason:
            'the old project-path base-href breaks every asset URL on '
            'catlabstudios.com',
      );
      expect(
        RegExp(r'--base-href\s+/\s*$', multiLine: true).hasMatch(text),
        isTrue,
        reason: 'expected --base-href / for the apex domain',
      );
    });

    test('CNAME ships with the build so deployments keep the domain', () {
      expect(
        cname.existsSync(),
        isTrue,
        reason:
            'web/CNAME is copied into build/web and travels with the '
            'Pages artifact',
      );
      expect(cname.readAsStringSync().trim(), 'catlabstudios.com');
    });

    test('no web asset hard-codes the old project path', () {
      for (final file in [File('web/index.html'), manifest]) {
        expect(
          file.readAsStringSync().contains('/catlab_studios/'),
          isFalse,
          reason: '${file.path} still points at the old sub-path',
        );
      }
    });

    test('privacy policies for shipped apps are carried on the domain', () {
      // These URLs are referenced by published store listings; moving the
      // domain to this repo must not take them offline.
      for (final slug in ['purrlove', 'cat-purr-relax']) {
        final page = File('web/privacy/$slug/index.html');
        expect(
          page.existsSync(),
          isTrue,
          reason: 'catlabstudios.com/privacy/$slug/ must keep resolving',
        );
        expect(page.readAsStringSync().toLowerCase(), contains('privacy'));
      }
    });
  });
}
