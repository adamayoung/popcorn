# Skill-Improvement Log

A durable record of every skill-improvement proposal raised by `/deliver`'s
**Phase 6 recurring-pattern scan**, and the decision on it. Newest at the top.

**Why this exists:** the Phase 6 scan surfaces proposals and waits for approval.
Without a memory of past decisions, it would re-propose ideas already **applied** or
deliberately **deferred/rejected** — wasting attention and re-litigating settled
calls. The scan **consults this log before proposing** and skips any pattern already
decided here. Record both the *yes* and the *no* (with rationale) — the *no*s are
what stop the loop repeating itself.

Status values: **applied** · **deferred** · **rejected**.

Format per entry:

```text
### <date> — <short title> · <applied|deferred|rejected>
- **Pattern:** what kept recurring (and the retro entries it appeared in).
- **Decision:** what was agreed, and where it landed (skill + commit/PR) if applied.
- **Rationale:** one or two sentences — why this call.
- **Reconsider when:** (deferred/rejected only) the condition under which the scan
  should resurface this — or `n/a` for applied entries.
```

Keep this five-field shape on every entry so the scan can parse the log
consistently — in particular **Decision** (status) and **Reconsider when** are the
two fields the dedup step keys on.

---

<!-- Newest entry goes here. -->
