# Archinario Agent

One laptop tool for drawing architecture diagrams through your AI agent.
CLI commands and a stdio MCP server share the same client and protocol.
The agent/model runs in your chosen client; this tool does not host an LLM.

**Repository:** [archinario/archinario-agent](https://github.com/archinario/archinario-agent).
Download a published version from [GitHub Releases](https://github.com/archinario/archinario-agent/releases).
The matching board-agent feature must be available on your Archinario instance;
you can also connect to a local development instance.

## How it works

1. Install the binary on your laptop (macOS, Windows or Linux).
2. Open an Archinario board: File -> Board agent -> Allow diagram access.
3. Save the displayed connection JSON to a private file outside any repository.
4. Point CLI/MCP at that file, close the dialog and leave the board tab open.
5. Ask your agent to read and edit the board. A batch appears in the browser and
   is one Undo action. Stop access from the board whenever you want.

Only the selected diagram is accessible, for up to30minutes. No portal source,
Go server, PostgreSQL, Docker, Node or API key for an LLM is needed on your laptop.
You need an MCP-capable client/agent or a terminal. Browser suspension may pause
its heartbeat; the client reports unavailable instead of silently queueing edits.

## Installation

### Ready-made releases

Download the matching archive from the repository's GitHub Releases and verify
its SHA256 against `SHA256SUMS`. Extract `archinario` (`archinario.exe` on Windows)
into a user-owned directory. Six combinations are prepared:
macOS/Linux/Windows x amd64/arm64. No administrator access is needed.

Convenience scripts are in `scripts/install.sh` and `scripts/install.ps1`.
Download and inspect them, then run for a **published, explicit** version:

```sh
sh install.sh v0.1.0
```

```powershell
.\install.ps1 -Version v0.1.0
```

Both verify SHA256 before installing. They do not edit shell profiles or MCP
settings. Use the printed absolute path in your client. The release workflow
creates a draft release for review; its existence does not mean it is published.

### Build from source (available from this folder now)

```sh
go build -o bin/archinario ./cmd/archinario
./bin/archinario version
./bin/archinario schema
./bin/archinario catalog --query database
```

Go1.26 is needed only for source builds. This module builds independently of the
portal; it contains only client code, wire types and a catalogue snapshot.

## CLI

Set `ARCHINARIO_CONNECTION_FILE` to your private JSON file with `url`, `session`,
`token`. Alternative: environment `ARCHINARIO_URL`, `ARCHINARIO_SESSION`,
`ARCHINARIO_TOKEN`. Never pass tokens in command-line flags or commit them.

```sh
export ARCHINARIO_CONNECTION_FILE=/private/path/connection.json
archinario read --section all
archinario apply --file patch.json --dry-run
archinario apply --file patch.json
archinario status --request orders-001
```

JSON data goes to stdout; structured errors go to stderr. Metadata commands
schema/catalog/version work without credentials. Read pages support offset/limit.
Full contract and examples: [usage](docs/usage.md).

## MCP

Command: absolute path to the installed `archinario` binary.
Arguments: `["mcp"]`. Environment: `ARCHINARIO_CONNECTION_FILE` points to the private
connection file. Standard JSON client example:

```json
{"mcpServers":{"archinario":{"command":"/absolute/path/archinario","args":["mcp"],"env":{"ARCHINARIO_CONNECTION_FILE":"/private/path/connection.json"}}}}
```

Client configuration formats vary. Preserve existing MCP entries when adding
this one; a running agent session may need to reload connections.
Four tools: archinario_read_board, archinario_list_components,
archinario_apply_patch, archinario_get_request.

Agent rules: [context](docs/agent-context.md).
Copyable [installation prompt](docs/install-prompt.md).
Maintainer [release instructions](docs/releasing.md).
