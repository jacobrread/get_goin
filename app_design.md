# get_goin App Design Document

## Purpose
A mobile app to gamify exercise, inspired by DuoLingo, where users set exercise goals, track progress on a calendar, and earn/spend a fake currency based on their achievements.

## Platforms
- iOS
- Android

## User Experience & Flow
- Single-user, no registration/login required.
- Onboarding: User sets up one or more goals on first launch.
- Multiple goals supported (reps, time, distance).
- Custom goals are not included in MVP.
- Users can edit or delete goals after creation (editing may be limited in future versions).
- Goal durations: user selects from 1 week, 2 weeks, 1 month, or 2 months.
- If a user misses a day, a user-defined amount is deducted from their total. Streak resets after two consecutive misses.

## Calendar & Progress
- Calendar is the main screen, showing current and past months.
- Days are colored based on success/failure.
- Top or bottom bar displays stats: streaks, totals, etc.
- Future: week/month/year views.

## Monetary System
- Each goal has a user-defined value per unit (e.g., $0.10 per pushup).
- Gains and losses are set per goal.
- All “money” is tracked as a single total across all goals.
- Users can "spend" their total for fun (subtracts from total, cannot go negative).

## Notifications & Gamification
- App sends reminders to complete goals; users choose from preprogrammed notification options.
- Optional motivational messages, badges, and levels.

## Visual Style
- Animated, fun, and friendly—similar to DuoLingo.
- Support for dark mode from the start.

## Social/Future Features (not MVP)
- Share streaks/progress with friends.
- Leaderboards and group challenges.

---
This document defines the MVP design. Update as features evolve.
