# Archinario Agent

**Describe a system. Draw it with your agent. Keep shaping it on the board.**

Archinario Agent connects your AI agent to the
[Archinario architecture board](https://archinario.com/design). Turn an idea into
a diagram, explore alternatives and edit the result together with your agent.
One local binary provides both a CLI and an MCP server for macOS, Windows and Linux.

**[Open the board →](https://archinario.com/design)** ·
[Explore Archinario](https://archinario.com/) ·
[Download CLI / MCP](https://github.com/archinario/archinario-agent/releases/latest)

## Meet Archinario

[Archinario](https://archinario.com/) is a visual workspace for designing systems
and learning how they work. Use the board for your own architecture, or explore
the [courses and interactive laboratories](https://archinario.com/courses).

- **Build a system visually.** Connect services, databases, message brokers and
  Kubernetes components, then choose open-source technologies for your blocks.
- **See the connections in motion.** Animated flows make diagrams easier to
  follow when explaining an architecture.
- **Work with an agent and by hand.** Ask for changes, adjust blocks yourself and
  undo an agent's batch as a single action.
- **Learn through experiments.** Explore topics such as load balancing, caching
  and queues in interactive lessons.

The board can be used without an account; projects are saved in your browser.
The CLI/MCP package in this repository is open source. Your AI model runs in your
chosen agent client; Archinario Agent does not host or include an LLM.

## Try it with your agent

1. **[Open the architecture board](https://archinario.com/design)** and create or
   open a project.
2. Choose **File → Board agent → Allow diagram access**.
3. Click **Copy prompt** and paste it into your trusted local coding agent.
   The prompt includes the official download, installation instructions and
   credentials for the current diagram. Your agent needs permission to install
   local tools; MCP clients may require a reload after configuration.
4. Close the connection dialog and **keep the board tab open**. Once connected,
   ask your agent to draw something:

> Draw an order-processing system: a client, an API service, PostgreSQL, a message
> broker and a worker. Connect the request and background-processing paths, label
> the connections and leave room for me to extend the diagram.

Changes appear on the same board you can edit manually. Use Undo to revert a
batch, or stop agent access from the board whenever you want.

**[Start your first diagram →](https://archinario.com/design)**

Prefer a manual setup? Follow the steps below or use the
[standalone installation prompt](docs/install-prompt.md).

## Manual connection

1. Install the binary on your laptop (macOS, Windows or Linux).
2. Open the [Archinario board](https://archinario.com/design):
   File → Board agent → Allow diagram access.
3. Expand **Manual connection data** and save the connection JSON to a private
   file outside any repository.
4. Point CLI/MCP at that file, close the dialog and leave the board tab open.
5. Ask your agent to read and edit the board. A batch appears in the browser and
   is one Undo action. Stop access from the board whenever you want.

Only the selected diagram is accessible, for up to 30 minutes. The copied prompt
contains a temporary access key: share it only with your trusted agent.
No portal source,
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

### Build from source

```sh
go build -o bin/archinario ./cmd/archinario
./bin/archinario version
./bin/archinario schema
./bin/archinario catalog --query database
```

Go 1.26 is needed only for source builds. This module builds independently of the
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
