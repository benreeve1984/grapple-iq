# Changelog

All notable changes to the Grapple IQ data field will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-20

### Added
- Initial release of Grapple IQ data field
- CLASS and COMBAT training modes
- LAP button mode toggle with vibration feedback
- DataFieldAlert banner notifications on mode change
- FIT Contributor fields for mode tracking:
  - `mode_code` (record-level, updated every second)
  - `mode_lap_code` (lap-level)
  - `goal_mode` (session-level)
  - `z1_target_min` (session-level)
- Heart rate cap monitoring with 10-second debounce
- Configurable settings via Connect IQ app:
  - HR Cap (BPM)
  - Goal Mode (Class/Hybrid/Combat)
  - Z1 Target Minutes
- Support for 1/2/3/4-field layouts
- Compatibility with 100+ Garmin devices
- Helper modules for safe device capability handling:
  - FitSchema for FIT field creation
  - Haptics for vibration with fallbacks
  - Alerts for banner notifications