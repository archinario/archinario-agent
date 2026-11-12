# Maintainer publication

Planned owner is the GitHub organization archinario (GitHub Free is sufficient).
Confirm the organization address before first publication; it determines module
imports, release URLs and installer links. One repo/binary ships both CLI and MCP.

Portal checkout: `agent/` is a standalone module, no backend/Next/lesson source.
Use `node scripts/export-agent-repo.mjs /tmp/archinario-agent-public` from the portal
root to prepare an allowlisted public tree. Review files, initialize a separate Git
repository in that tree and push only it to the new organization repository.
Do not change portal visibility or push portal history into the public package.

Before publication:
- Confirm organization, public repo name and the MIT license for the agent package.
- Choose commit author/email explicitly. Organization branding does not hide Git
  author metadata; use your account's actual GitHub noreply address if desired.
  Do not fabricate another person's identity or rewrite portal history.
- `go test ./...`, source build and backend/browser protocol integration must pass.
- Ensure embedded catalogue matches the running server's component catalogue.

Once the public repository is configured:
1. Push reviewed source, CI and release workflow from this package root.
2. Tag a chosen version, e.g. v0.1.0, and push the tag.
3. GoReleaser builds six archives + SHA256SUMS into a GitHub draft release.
4. Review assets/checksums and test platform binaries, then publish the draft.
5. Update preparation-status wording and portal download links to the actual release.

Local checks: `goreleaser check`; `goreleaser release --snapshot --clean` produces
artifacts without publishing. No Apple/Windows code-signing credentials are
configured. CI runs natively on Windows/macOS/Linux after the repo exists.
No registry, paid GitHub plan or separate machine account is required.
