# Start here

This folder is a complete software development process: from a person's idea to a shipped, hardened tool,
with a gate at every step. It is written for Claude Code, and a person can follow it by hand too.

## Set up (once per project)

1. Unzip this folder somewhere it can stay, for example beside your projects. Keep it read-only: it is the
   process, not a project.
2. Create or open the project's repository.
3. Copy this folder's `CLAUDE.md` into the project's root as `CLAUDE.md` (if the project already has one,
   append this one to it). Claude Code reads a `CLAUDE.md` only in the project it is working in; without
   this step none of the rules apply. Adjust any paths and folder names it mentions to the project.
4. Start Claude Code in the project and say:

   > Follow `<path to this folder>/RUNBOOK.md` from step 0 for this project. The idea is: <one paragraph>.

## What to expect

- **Step 0** sets up the two records (a narrative worklog and a per-unit code worklog) and a gate that
  refuses a push without them.
- **Step 1** writes the requirements (URS) with you, every line marked as quoted from you or inferred. A
  cold test and a read-back follow. Nothing is built until you put your name in the URS header.
- **Step 2** builds a working prototype in Next.js on invented data, for you to click through.
- **Step 3** writes the architecture: every technical choice beside the option it beat.
- **Steps 4 and 5** write the build plan and test it adversarially before any code.
- **Step 6** builds it one slice at a time, each with evidence, and hardens it before release.
- **Step 7** records every slice.

You will be asked a question at each gate (approval of the URS, the prototype, the architecture, the release),
and Claude will ask before every commit and give you the push command rather than pushing itself. Those are
the points where the process needs you; between them it works on its own.

## What is in this folder

| File | Use |
|---|---|
| `RUNBOOK.md` | The steps and their gates, one page |
| `Development-Process.md` | Why each step exists |
| `CLAUDE.md` | The rules Claude follows, including the working agreement |
| `Phase 1 URS-template.md`, `Phase 2 prompt-claude.md`, `Phase 3 Technical Architecture & Data Flow.md` | The URS, prototype and architecture steps |
| `Master-Build-Prompt.md`, `Master-Test-Prompt.md`, `Master-Execute-Prompt.md` | Plan, test the plan, build |
| `keys.md`, `keys-core.md`, `pre-ship-hardening.md` | The engineering standard and the hardening method the prompts enforce |
| `Progress-Documentation.md`, `WORKLOG-entry-template.md`, `CODE_WORKLOG-template.md`, `check_worklog.sh`, `stop-hook-settings.json` | The records and their gate |

## Good to know

- Quality depends on the model running the process: the same model follows it the same way on any account;
  a smaller model follows the steps but checks less deeply.
- `keys.md` cites the source documents its practices were drawn from; those sources are not included. Every
  practice is written out in full, so nothing depends on them.
