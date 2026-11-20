# Dungeons Analytics

Dungeons Analytics is a native Lua addon project for retrospective dungeon analysis in World of Warcraft: Forever. The planned report relates each party member's recorded performance to boss attempts, trash combat and downtime across a run. The first deliverable is an opt-in diagnostic for the Forever client.

The development addon records a bounded, local diagnostic on WoW: Forever. Capture is opt-in and records the installed build, availability of meter fields, candidate session timing and dungeon events. It can probe generic native UI components and export its report without raw player names or GUIDs. Live dungeon, persistence and interface acceptance are tracked in [the test plan](docs/TESTING.md). See [the roadmap](docs/ROADMAP.md) for product milestones and [the capability matrix](docs/WOW_FOREVER_API.md) for source evidence.

## Run the diagnostic

[Install the development addon](docs/INSTALLATION.md), then run `/da diag` in chat for help.

| Command | Action |
| --- | --- |
| `/da diag start` | Opt in and take a baseline. |
| `/da diag snapshot` | Capture a bounded sample during an active diagnostic. |
| `/da diag ui` | Open the native component probe outside combat. |
| `/da diag stop` | End capture and keep the local observations. |
| `/da diag export` | Open the selectable local report outside combat. |

- [Installation and client test preparation](docs/INSTALLATION.md)
- [Product scope and requirements](docs/PRODUCT.md)
- [Architecture and data model](docs/ARCHITECTURE.md)
- [Development and contributions](CONTRIBUTING.md)
- [Automated and real-client verification](docs/TESTING.md)

Dungeons Analytics is an independent project. The addon will ship English and Spanish text and process its local records within the game.

## Contribute and share

Anyone with a GitHub account can open an issue or propose a pull request from a fork. Read the [contribution guide](CONTRIBUTING.md). Created by [sebasgrios](https://github.com/sebasgrios).

The [PolyForm Noncommercial License 1.0.0](LICENSE) permits sharing and modifying the project for its permitted purposes. Distributions must retain the license or its URL and the creator credit in [NOTICE](NOTICE).
