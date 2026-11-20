# Development

Use Git, Node.js 22.12+ for OpenSpec and repository checks, and Lua 5.1 for addon syntax and unit tests. GitHub Actions uses Lua 5.1, Luacheck and StyLua for runtime changes. Luacheck catches globals and suspicious usage, and StyLua enforces the Lua 5.1 style. Busted and LuaLS are optional future additions if the plain Lua harness or editor support becomes insufficient.

```sh
node scripts/validate-repository.mjs
node --test tests/*.test.mjs
npx --yes @fission-ai/openspec@1.16.0 validate --all --strict --no-interactive
```

Once a reviewed change adds runtime files, run the Lua syntax, lint and formatter commands on the same paths as CI. Keep pure tests independent of the game, use fixtures for client assumptions and test each WoW mock for the documented unavailable and restricted cases. [Testing](TESTING.md) lists real-client scenarios and the result format.

Reference material lives in documentation with its upstream provenance. Keep game dumps, local character records and extracted addon code out of the repository.
