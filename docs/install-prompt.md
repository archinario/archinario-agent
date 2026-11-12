# Installation prompt

Replace RELEASE_TAG and CONNECTION_FILE with the chosen public release and your
private connection-file path. Do not paste the connection token into the prompt.

> Install Archinario Agent from the official GitHub repository
> https://github.com/archinario/archinario-agent, release RELEASE_TAG, on my laptop.
> Detect my OS and CPU; download the matching GitHub Release archive and
> SHA256SUMS for that same release. Verify SHA256 before running the executable.
> Install into a user-owned directory without sudo. Verify `version`, `schema`
> and `catalog --query database`. Use the release binary; building source is a
> fallback only if there is no compatible release and Go1.26 is already available.
> Configure an MCP connection named archinario in the MCP client I am using:
> absolute executable path, argument mcp, environment ARCHINARIO_CONNECTION_FILE
> set to CONNECTION_FILE. Preserve all existing MCP connections and unrelated
> settings. If the client/config location is unknown, ask which client to configure.
> Never print, upload or commit the connection token. Ask me to create the private
> connection file through File -> Board agent on Archinario if it does not exist;
> do not invent credentials or ask me to paste the token into chat.
> Explain any required client reload. Then use read-only calls to list tools and
> read the board summary. Do not draw or remove anything until I request a diagram.
> If the repository/release is unavailable, stop with a clear message; do not switch
> to an unofficial download or silently install a different package.
