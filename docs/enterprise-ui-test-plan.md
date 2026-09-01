# Enterprise UI Test Plan

## Objective

Verify Orqestra enterprise redesign across behavior, responsive layout, accessibility, visual states, and safety paths on mobile and tablet.

## Scope

Included:

- Enterprise light and dark themes.
- Shared loading, error, and empty states.
- Adaptive mobile and tablet navigation.
- Auth form validation and large-text safety.
- Device fleet, device detail, and capability controls.
- Pairing scanner validation and claim recovery.
- Automation list and builder validation.
- Existing realtime and optimistic state behavior.

Excluded from automated widget tests:

- Physical camera permission dialogs.
- Real QR camera decoding.
- Real backend authentication, pairing, and automation generation.
- Pixel-perfect golden tests.
- OS-level screen reader behavior.

## Automated Test Strategy

### Theme

- Light and dark themes construct successfully.
- Enterprise component themes exist.
- Theme uses Material 3.

### Shared States

- Loading state renders progress and message.
- Error state renders recovery action.
- Recovery callback executes once.
- Empty state renders title, description, icon, and optional CTA.

### Responsive Navigation

- Width below 720 px renders `NavigationBar`.
- Width 720 px and above renders `NavigationRail`.
- Only one navigation mode exists at a time.

### Capability Controls

- Boolean action sends requested value.
- Malformed color value does not crash rendering.
- Offline/disabled control prevents command input.
- Color selection targets remain at least 48 px.

### Device Detail

- Optimistic command survives route removal and reopening.
- Loading, error, and missing-device states preserve page structure.
- Offline device controls are disabled.

### Pairing

- Invalid claim arguments render recovery state.
- Claim recovery exposes `Scan again` action.
- QR parser accepts exactly `orqestra://pair/{device_code}/{token}`.
- QR parser rejects wrong scheme, host, or segment count.
- Duplicate accepted QR does not navigate twice.

### Automation Builder

- Empty AI prompt displays visible validation error.
- Manual mode displays device-based selectors instead of raw ID fields.
- Manual save displays required-field errors.
- AI draft displays trigger and actions before confirmation.

### Existing Realtime Regression

- WebSocket events parse correctly.
- Reconnect obtains fresh token.
- Disconnect cancels pending reconnect.
- Realtime patch wins over stale REST snapshot.
- Optimistic command rollback only removes failed operation.

## Responsive Matrix

| Class | Width | Expected navigation | Expected content |
| --- | ---: | --- | --- |
| Compact | 360 px | Bottom navigation | Single-column cards |
| Medium | 600 px | Bottom navigation | Constrained single-column content |
| Expanded | 840 px | Navigation rail | Wider constrained content or grid |

Run important screens at each width with:

- Text scale 1.0.
- Text scale 2.0.
- Light theme.
- Dark theme.

## Screen State Matrix

| Screen | Loading | Error | Empty | Success | Recovery |
| --- | --- | --- | --- | --- | --- |
| Sign in | Button progress | Inline banner | N/A | Router redirect | Edit and retry |
| Sign up | Button progress | Inline banner | N/A | Router redirect | Edit and retry |
| Devices | Shared loading | Shared error | Pair CTA | Fleet cards | Retry/refresh |
| Device detail | Shared loading | Shared error | Missing/capability empty | Controls | Retry/back |
| Scanner | Processing copy | Invalid QR copy | N/A | Claim navigation | Rescan |
| Claim | Button progress | Inline banner | Invalid-link state | Home redirect | Scan again |
| Automations | Shared loading | Shared error | Create CTA | Rule cards | Retry/refresh |
| Builder | Button progress | Inline banner | Empty prompt validation | Draft/manual save | Edit/retry |

## Accessibility Checklist

- Icon-only actions have tooltips.
- Custom status components expose semantic labels.
- Status is represented by icon, text, and color.
- Interactive color targets are at least 48 x 48 px.
- Forms expose labels and inline errors.
- Auth fields expose autofill hints and keyboard actions.
- Core screens do not throw overflow at 200% text scale.
- Error containers preserve readable foreground contrast.
- Disabled/offline controls cannot trigger commands.

## Manual Device Checks

Required on Android or iOS hardware:

1. Launch scanner with camera permission not requested.
2. Deny permission and verify app remains recoverable.
3. Grant permission and scan valid Orqestra QR.
4. Hold QR in frame and verify one claim route opens.
5. Scan malformed QR and verify visible error.
6. Return from claim preview and verify scanner can retry.
7. Rotate device and verify overlay remains usable.
8. Enable system large text and verify auth, claim, and device controls remain scrollable.
9. Switch system light/dark mode and verify surfaces and status contrast.

## Commands

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test
```

## Acceptance Criteria

- All automated tests pass.
- No analyzer errors.
- Compact and expanded navigation tests pass.
- Malformed capability color cannot crash renderer.
- Invalid claim route has visible recovery action.
- Empty AI prompt and incomplete manual form fail visibly.
- Existing realtime and optimistic-state tests remain green.
- Manual camera checks completed before release candidate.

## Execution Record

Status values:

- `PASS`: verified successfully.
- `FAIL`: verified and failed.
- `BLOCKED`: environment or hardware unavailable.
- `PENDING`: not executed yet.

| Check | Status | Evidence |
| --- | --- | --- |
| Dart format check | PASS | `dart format --output=none --set-exit-if-changed lib test`: 43 files, 0 changed |
| Flutter analyzer | BLOCKED | Environment command returned `clean — nothing to commit` instead of analyzer diagnostics |
| Full Flutter tests | PASS | `flutter test`: 21 tests passed |
| Compact navigation | PASS | Widget test verifies `NavigationBar` at 360 px |
| Expanded navigation | PASS | Widget test verifies `NavigationRail` at 840 px |
| Shared state recovery | PASS | Widget test invokes error retry callback once |
| Theme construction | PASS | Light/dark Material 3 themes construct with enterprise component configuration |
| Malformed color regression | PASS | Capability renderer accepts malformed server color without exception |
| Invalid claim recovery | PASS | Invalid claim page renders `Scan again` recovery state |
| Empty automation prompt validation | PASS | Empty AI prompt and incomplete manual form show visible errors |
| Physical camera and permission checks | BLOCKED | Requires Android/iOS hardware session |

Execution date: 2026-08-31.
