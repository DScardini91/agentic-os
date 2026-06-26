---
description: Fast-lane calendar scheduling — checks conflicts and availability, then delivers a prefilled calendar event link the principal can open in one click. Works around MCP calendar read-only limitations.
triggers:
  - "/schedule"
  - "agenda isso"
  - "marcar reunião"
  - "schedule a meeting"
  - "agendar"
  - "coloca na agenda"
---

# Skill: schedule

## Purpose
Do all the scheduling work so the principal just clicks once.

## Steps

1. **Parse the request**
   - Title, date/time (or constraint like "this week"), duration (default 30 min)
   - Attendees — resolve names to emails from `control-plane/memory/` or email search
   - Location / video link / format

2. **Check before proposing**
   - Use calendar MCP (`outlook_calendar_search` or equivalent) to check the principal's conflicts — flag them, respect protected time from `control-plane/memory/self/`
   - If attendees are specified and the slot is open, use availability search (`find_meeting_availability` or equivalent) to find slots that work for all
   - Convert any UTC results to the principal's local timezone

3. **Deliver a one-click event link**

   For Outlook (preferred if M365 is wired):
   ```
   https://outlook.office.com/calendar/deeplink/compose?subject=<urlencoded>&startdt=<YYYY-MM-DDTHH:mm:ss>&enddt=<...>&body=<urlencoded>&location=<...>&to=<email1,email2>
   ```

   For Google Calendar:
   ```
   https://calendar.google.com/calendar/render?action=TEMPLATE&text=<urlencoded>&dates=<YYYYMMDDTHHMMSS>/<YYYYMMDDTHHMMSS>&details=<urlencoded>&location=<urlencoded>&add=<email1,email2>
   ```

   - Draft a sharp 1-2 line event body (purpose + agenda)
   - If multiple slot options exist, give 2-3 links (one per slot), best first

4. **After confirmation**
   - If the principal confirms it was booked, log it in the daily log or relevant project file

---

## Rules
- Tight format: conflict check in one line each, then the link(s). No verbose explanation of the read-only limitation every time.
- Never embed confidential content in URL parameters — title and public attendees only.
- If calendar MCP is not authenticated, tell the principal and deliver a pre-filled link from the details alone.
