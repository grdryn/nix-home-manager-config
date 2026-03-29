- Use the "Assisted-By" trailer in commit messages rather than "Co-Authored-By" trailer when attributing Claude
- Don't add the  "Generated with Claude Code" line (or any such variation) to commit messages.
- Whenever a jira issue link is provided, it should be put at the top of the git commit description, below the summary/title line
- git commit summary line should be no more than 50 characters

## Code Navigation and Analysis

**Prefer LSP and language-aware tools over grep/text search for code analysis.**

When tracing call sites, finding references, checking implementations, or understanding type relationships, use tools that parse the language semantically:

- **LSP tool** (when available in IDE): `findReferences`, `goToDefinition`, `goToImplementation`, `incomingCalls`, `outgoingCalls`, `hover` for type info.
- **CLI language servers** as fallback: `gopls references file.go:#offset`, `gopls call_hierarchy`, etc. These work without a running IDE.
- **Grep/Glob**: Use only for text-level searches (log messages, string literals, config values) or as a secondary filter after LSP narrows the scope. Never rely on grep alone to answer "what calls this function" or "what types flow into this parameter"—it can't resolve interfaces, embedded types, or cross-package references.

**Why this matters:** Grep finds string matches. LSP finds semantic relationships. Grep gives false negatives on interface implementations, type aliases, and cross-package usage. LSP is deterministic—if it says there are 9 references, there are exactly 9.
