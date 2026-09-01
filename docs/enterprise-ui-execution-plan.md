# Enterprise UI Execution Plan

## Objective

Upgrade Orqestra Flutter from MVP UI into professional enterprise-grade IoT mobile and tablet experience.

Target product direction:

- Visual style: industrial premium.
- Target platform: mobile and tablet.
- Scope: all current Flutter screens.
- Brand assets: not available yet, use temporary text wordmark and system font.

Primary goal: make app feel reliable for enterprise IoT demo without inventing unsupported backend data or adding unnecessary dependencies.

## Design Principles

- Use native Flutter Material 3 first.
- Keep diff small and boring.
- Build reusable components only when used by multiple screens.
- Prefer existing dependencies; do not add design packages.
- Status must use text, icon, and color together.
- All states need recovery path: loading, error, empty, offline, pending, success.
- Mobile first, tablet adaptive second.
- Do not display fake enterprise metadata.
- Accessibility is baseline, not polish.

## Visual Direction

Industrial premium theme:

- Dark navy and charcoal base.
- Cyan and teal primary actions.
- Thin borders and layered surfaces.
- Moderate radius, minimal shadow.
- Dense but readable cards.
- Strong page headers and operational status badges.
- Crisp icons with explicit labels.

Initial token targets:

| Token | Value | Use |
| --- | --- | --- |
| Background | `#08111F` | Dark app background |
| Surface | `#101C2C` | Card and panel background |
| Surface high | `#17263A` | Raised card/header surface |
| Primary | `#22D3C5` | Main action and active state |
| Secondary | `#4F8CFF` | Secondary action and links |
| Success | `#32D583` | Online/success state |
| Warning | `#F5B942` | Warning/degraded state |
| Error | `#F97066` | Error/critical state |
| Text primary | `#F4F7FB` | Main text on dark theme |
| Text muted | `#94A3B8` | Supporting text |
| Border | `#26374D` | Card/input borders |

Light theme must exist for system theme and accessibility. It can use same semantic roles with lighter surfaces.

## Current UI Gaps

- `lib/main.dart` only uses `ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true)`.
- No separated app theme, dark theme, spacing tokens, radius tokens, or component theme.
- No adaptive app shell for tablet.
- No shared loading/error/empty state components.
- Auth screens are basic forms and not scroll-safe enough for large text/keyboard.
- Device list is simple `ListTile`, not fleet view.
- Device detail lacks overview card, empty capability state, and pending control state.
- Capability color parser can crash on malformed server data.
- QR scanner lacks overlay, permission state, manual fallback, and duplicate scan guard.
- Claim preview has minimal information and weak recovery actions.
- Automation list and builder still feel like debug tools.
- Accessibility gaps: missing tooltips, semantics, target sizes, and non-color status labels.

## Phase 1: Theme Foundation

Create:

- `lib/core/theme/app_theme.dart`

Update:

- `lib/main.dart`

Implementation:

- Add `AppTheme.light()` and `AppTheme.dark()`.
- Use Material 3 `ColorScheme` with explicit semantic colors.
- Add typography scale through `TextTheme` based on system font.
- Add component themes for:
  - `AppBarTheme`
  - `CardThemeData`
  - `InputDecorationTheme`
  - `FilledButtonThemeData`
  - `OutlinedButtonThemeData`
  - `TextButtonThemeData`
  - `FloatingActionButtonThemeData`
  - `NavigationBarThemeData`
  - `NavigationRailThemeData`
  - `ChipThemeData`
  - `SnackBarThemeData`
  - `DialogThemeData`
  - `SliderThemeData`
  - `SwitchThemeData`
- Set `theme`, `darkTheme`, and `themeMode: ThemeMode.system`.
- Keep `ProviderScope` unchanged.

Definition of done:

- App uses centralized theme.
- Light and dark theme both compile.
- Existing screens still render without layout regression.

## Phase 2: Shared UI Components

Create only if used by at least two screens:

- `lib/core/widgets/app_state_view.dart`
- `lib/core/widgets/status_badge.dart`
- `lib/core/widgets/responsive_page.dart`
- `lib/core/widgets/section_card.dart`

Components:

- `AppStateView.loading`
- `AppStateView.error`
- `AppStateView.empty`
- `StatusBadge`
- `ResponsivePage`
- `SectionCard`

Behavior:

- Loading state supports optional message.
- Error state has title, message, and retry callback.
- Empty state has icon, title, message, primary action, and optional secondary action.
- Status badge renders icon, label, color, and semantic label.
- Responsive page constrains content width on tablet.

Definition of done:

- Device list and automation list share state components.
- Status labels no longer rely only on color.
- Components remain small and local to current app needs.

## Phase 3: Adaptive App Shell

Update:

- `lib/core/router/app_router.dart`

Possible new file:

- `lib/core/widgets/adaptive_scaffold.dart`

Implementation:

- Add authenticated shell around main routes.
- Main destinations:
  - Devices: `/`
  - Automations: `/automations`
- Mobile uses `NavigationBar`.
- Tablet uses `NavigationRail` at medium width and above.
- Pairing scanner remains pushed route, not permanent nav item.
- Device detail remains deep route.
- Automation new remains pushed route.
- Add safe handling for `/pair/claim` route extras.

Definition of done:

- Navigation is consistent across Devices and Automations.
- Tablet layout avoids stretched full-width lists.
- Invalid claim route shows recovery UI, not cast crash.

## Phase 4: Auth Redesign

Update:

- `lib/features/auth/sign_in_page.dart`
- `lib/features/auth/sign_up_page.dart`

Implementation:

- Add branded auth layout with `Orqestra` wordmark and product tagline.
- Use `SafeArea` and scroll-safe layout.
- Keep max form width around 400 px.
- On tablet, show product value panel and form panel side by side.
- Convert validation to visible inline form errors.
- Add autofill hints.
- Add keyboard actions.
- Add password visibility toggle.
- Replace raw snackbar-only errors with visible error banner.
- Keep sign in/sign up navigation clear.

Definition of done:

- Auth works at 360 px width.
- Auth works with keyboard visible.
- Auth works with 200% text scale.
- Loading state keeps form stable.

## Phase 5: Device Fleet Redesign

Update:

- `lib/features/devices/device_list_page.dart`

Implementation:

- Add enterprise page header: title, short description, total devices, online count.
- Add search field.
- Add basic status filter if low-cost with current data.
- Use `RefreshIndicator` for all states where possible.
- Empty state includes pairing CTA.
- Error state includes retry.
- Device item becomes card with:
  - device name
  - status badge
  - capability count
  - last known status text if available
  - route affordance
- Tablet layout uses grid or constrained list.
- Logout gets tooltip and confirmation.
- Pairing FAB gets tooltip and semantic label.

Definition of done:

- Empty state is actionable.
- Error state is recoverable.
- Online/offline status uses icon and label.
- Device list no longer looks like default prototype list.

## Phase 6: Device Detail Redesign

Update:

- `lib/features/devices/device_detail_page.dart`
- `lib/features/devices/capability_control.dart`
- `lib/features/devices/device_providers.dart` if pending state needs provider support.

Implementation:

- Keep app bar visible for loading, error, and not found states.
- Add device overview card with name, status, identifier, and capability count.
- Add capabilities section with grouped cards.
- Add empty capability state.
- Add retry action for detail load failure.
- Show offline/degraded explanation if controls cannot be trusted.
- Add pending visual for control mutation if current provider shape allows it.
- Keep optimistic update behavior, but expose errors clearly.

Capability control upgrades:

- Boolean: show `On`/`Off` text and semantic label.
- Metric: show unknown state and consistent unit spacing.
- Range: preserve decimals; show min, max, current value.
- Color: safe parse malformed color values.
- Color swatches: 48 px tap target, selected state, color name/hex, cancel action.

Definition of done:

- Detail page never becomes blank without explanation.
- Malformed color data cannot crash render.
- Controls remain accessible and understandable offline.

## Phase 7: Pairing Flow Redesign

Update:

- `lib/features/pairing/scan_page.dart`
- `lib/features/pairing/claim_preview_page.dart`

Implementation for scanner:

- Add camera overlay with scan frame and instruction text.
- Add processing state after QR accepted.
- Guard duplicate scans.
- Strictly validate QR path/query data.
- Add invalid QR feedback.
- Add permission denied/camera error UI when exposed by scanner widget.
- Add manual pairing fallback entry point.
- Add tooltip and semantic labels for scanner controls.

Implementation for claim preview:

- Use scroll-safe verification card.
- Make device code selectable and monospace.
- Show structured error banner.
- Add `Scan again` and cancel actions.
- Add loading state in button with stable width.
- Use constrained layout on tablet.

Definition of done:

- QR malformed input is rejected visibly.
- Claim route can recover from invalid arguments.
- Pairing flow has clear primary and secondary actions.

## Phase 8: Automation List Redesign

Update:

- `lib/features/automations/automation_list_page.dart`

Implementation:

- Add page header with total automations and enabled count.
- Add search field.
- Add filter chips for all/enabled/disabled if cheap with current data.
- Add pull-to-refresh.
- Use cards instead of raw list tiles.
- Show automation name, enabled badge, and action count.
- Fix pluralization: `1 action`, `N actions`.
- Add empty state with create CTA.
- Add error state with retry.
- Add tooltip to FAB.

Definition of done:

- Automation list looks operational, not debug-only.
- Empty/error states match device list pattern.
- Enabled state is visible through label, icon, and color.

## Phase 9: Automation Builder Redesign

Update:

- `lib/features/automations/automation_form_page.dart`
- `lib/features/devices/device_providers.dart` if device list data is needed for picker.

Implementation:

- Split creation modes with segmented control:
  - AI assistant
  - Manual builder
- AI assistant mode:
  - Prompt input with examples.
  - Generate button with spinner.
  - Generated draft card shows trigger and actions.
  - Confirm save button.
  - Regenerate and edit-copy affordance if cheap.
- Manual builder mode:
  - Use `Form` and validation.
  - Device picker instead of raw device ID where current providers allow.
  - Capability picker instead of raw key where current data allows.
  - Type-aware value input for boolean, range, color, metric.
  - Review summary before save.
- If API only supports one manual action today, keep one action and document limitation in UI copy.
- Required field errors must be visible and focusable.

Definition of done:

- Empty prompt no longer fails silently.
- Manual save no longer fails silently.
- User does not need to know internal IDs for common path.
- AI-generated rule can be reviewed before save.

## Phase 10: Accessibility Pass

Apply across all changed screens:

- Tooltip for every icon-only action.
- `Semantics` labels for custom visual controls.
- Minimum 48 px tap target.
- Visible focus affordances through Material defaults.
- No status relies only on color.
- Error banners use `colorScheme.errorContainer` and readable text.
- Large text scale should not overflow core flows.
- Auth fields have autofill and keyboard action.
- Loading and progress states expose text label.

Definition of done:

- Core flows usable with 200% text scale.
- Custom controls have semantic labels.
- Important action targets meet minimum size.

## Phase 11: Safety Fixes Required During Redesign

Fix while touching related files:

- Claim route cast crash in `lib/core/router/app_router.dart`.
- Malformed color parser crash in `lib/features/devices/capability_control.dart`.
- QR duplicate scan risk in `lib/features/pairing/scan_page.dart`.
- Missing retry paths in list/detail pages.
- Session restore issue if confirmed in `lib/features/auth/auth_controller.dart` or repository layer.

Do not expand scope into backend or new product capabilities unless current API already supports it.

## File Change Plan

New files:

```text
lib/core/theme/app_theme.dart
lib/core/widgets/adaptive_scaffold.dart
lib/core/widgets/app_state_view.dart
lib/core/widgets/responsive_page.dart
lib/core/widgets/section_card.dart
lib/core/widgets/status_badge.dart
```

Likely updated files:

```text
lib/main.dart
lib/core/router/app_router.dart
lib/features/auth/sign_in_page.dart
lib/features/auth/sign_up_page.dart
lib/features/devices/device_list_page.dart
lib/features/devices/device_detail_page.dart
lib/features/devices/capability_control.dart
lib/features/devices/device_providers.dart
lib/features/pairing/scan_page.dart
lib/features/pairing/claim_preview_page.dart
lib/features/automations/automation_list_page.dart
lib/features/automations/automation_form_page.dart
```

Avoid editing generated files:

```text
*.freezed.dart
*.g.dart
```

## Implementation Order

1. Add theme foundation and connect it in `main.dart`.
2. Add shared components used by multiple screens.
3. Add adaptive shell and safe claim route handling.
4. Redesign auth screens.
5. Redesign device list.
6. Redesign device detail and capability controls.
7. Redesign pairing scanner and claim preview.
8. Redesign automation list.
9. Redesign automation builder.
10. Run accessibility pass.
11. Run format, analyze, and tests.
12. Fix regressions with smallest possible diff.

## Definition of Done

- App has centralized light and dark enterprise theme.
- Main navigation adapts for mobile and tablet.
- Every screen has professional loading, error, empty, and success/recovery states where relevant.
- Device and automation areas no longer look like raw Flutter starter UI.
- Pairing flow has scanner guidance, duplicate-scan guard, and invalid input feedback.
- Capability controls handle malformed values safely.
- Auth and forms are scroll-safe and accessible.
- `flutter analyze` passes.
- `flutter test` passes.
- Manual checks pass on compact and tablet widths.

## Out of Scope

- New backend APIs.
- Fake device metadata.
- Advanced analytics.
- Firmware/OTA UI.
- RBAC/admin desktop console.
- Custom font licensing and brand asset integration.
- Golden test framework setup unless requested.
- New Flutter dependencies unless native Flutter cannot solve requirement safely.

## Risks

- Automation builder quality depends on available device/capability data in current providers.
- Scanner permission behavior depends on `mobile_scanner` exposed callbacks and platform config.
- Session restore may require repository/auth model work beyond visual redesign.
- Tablet polish may be limited if current navigation routes stay flat.

## Notes

- Keep UI copy concise and user-safe.
- Convert raw technical errors into readable messages where possible.
- Prefer deleting duplicate UI state code after shared state components exist.
- If two implementation options are equally correct, choose smaller diff.
