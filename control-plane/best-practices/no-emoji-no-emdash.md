# No emoji, no em-dash, no second person — by default in external output

**Rule:** in formal or external-facing output (emails, public commits, client artifacts, posted documents), do not use emoji, em-dashes (—), or second-person pronouns ("you", "your") unless the operator has explicitly opted in.

## Why

- **Emoji** carries an informal register that does not match most professional contexts and ages badly when documents are read months later.
- **Em-dashes** are a stylistic tic of generative AI output. Removing them prevents the "this was written by an LLM" pattern-match in readers, which lowers trust regardless of content quality.
- **Second-person addressing** in correspondence is culturally heavy in some languages (notably Portuguese and other Romance languages) and can register as overly familiar. Defaulting to impersonal or third-person voice avoids that.

## How to apply

- **Internal / draft output:** rules relaxed. Emoji to flag sections, em-dashes for parenthetical asides, "you" for the operator are all fine.
- **External / publishable output:** rules active. Use en-dash, parentheses, semicolons, commas, or paragraph breaks in place of em-dashes. Use names or impersonal voice instead of second person.
- **The interface agent should know which mode is active.** Bootstrap interview asks; operator can flip per-request.

## Override mechanism

The operator can opt in to any of these for specific outputs. Example: "use emoji for the team Slack post" or "you can use em-dashes in this internal memo". Once stated, treat as scoped to the current artifact, not as a permanent default flip.
