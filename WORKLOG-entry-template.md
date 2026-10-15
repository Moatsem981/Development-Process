# WORKLOG entry template

Copy the block below to the TOP of `docs/WORKLOG.md`. Newest entry first, always.

One `##` title per entry. Prose paragraphs, not bullet dumps. Bold only for the one named
lever in section 6. No em dashes. Define every jargon word the first time it appears. The
target reader is a graduate who was not in the room and does not have the context.

Do not invent a new layout. An entry that looks different from its neighbours stops the file
being readable as a single document, which is the only reason the file has value.

---

## YYYY-MM-DD: <a title that states the finding, not the task>

A definition first. A "<the one term the entry turns on>" means <plain definition, no jargon>.
<One or two sentences of why this entry exists at all, and what makes it worth reading.>

### 1. Situation

<What was true before. The problem as it presented, not as you later understood it. Include the
numbers you actually have: counts, sizes, durations. If you do not have a number, do not write
one.>

### 2. Task

<What had to be achieved, and the constraints that made it non-trivial. State what must NOT
change as explicitly as what must. Most of the design pressure lives in the constraints.>

### 3. Action

<What was done, in order, including the wrong turns. Name the instincts you refused and why:
"the obvious fix is X, and it is wrong here because Y" is the most useful sentence in an entry.
Name the software-engineering lever you pulled. The diagnostic process teaches more than the
final diff.>

### 4. Result

<What is true now. Verified numbers only: test counts, coverage figures, timings, before and
after. If you did not measure it, say so rather than implying it.>

### 5. Technical implementation

<How it works, pitched at a graduate. Define each concept from first principles BEFORE applying
it: what a cache is, then how this used one. When the change embodies a named concept (cache
invalidation, idempotency, fail-closed, single source of truth, defence in depth), teach the
concept, not only the local fix.>

<Honest limits. What this does not fix, what is still fragile, what depends on somebody
remembering rather than on a check. An entry with no limits section is an entry that has not
been thought about.>

### 6. What I would tell someone about this

<The transferable lesson, stated as a rule that applies beyond this change. One bold sentence
naming the lever. Then the tell: the observable symptom that should make a reader reach for this
lesson next time.>

### 7. Where it lives in the code

- Commits: `<short sha>`, `<short sha>`
- Code entries: CW-XXXX, CW-XXXX
- <What it is>: `<path>`
- <What it is>: `<path>`

One-sentence summary for a non-engineer: <one sentence, no jargon, that a stakeholder could
repeat accurately in a meeting.>
