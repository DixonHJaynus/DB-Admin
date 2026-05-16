<div align="center">

# 🤠 DB-Admin

### *A Comprehensive Western-Themed Admin Menu for RedM*

**Built for RSG Core · Powered by ox_lib · Styled like 1899**

[![Version](https://img.shields.io/badge/version-2.0.0-d4b078?style=for-the-badge&labelColor=2e1d15)](https://github.com)
[![RedM](https://img.shields.io/badge/RedM-Compatible-b8945a?style=for-the-badge&labelColor=2e1d15)](https://redm.gg)
[![License](https://img.shields.io/badge/license-MIT-6a8a3a?style=for-the-badge&labelColor=2e1d15)](https://opensource.org/licenses/MIT)
[![Lua](https://img.shields.io/badge/Lua-5.4-9a2820?style=for-the-badge&labelColor=2e1d15)](https://www.lua.org)

---

*"Authority of the Frontier"*

</div>

---

## ✨ Overview

**DB-Admin** is a fully-featured, beautifully-themed administrative menu designed exclusively for RedM servers running RSG Core. It combines a comprehensive suite of admin tools with a custom-built rugged Western UI — featuring dark wood paneling, brass accents, branded typography, and ledger-book aesthetics that match the era.

Every feature has been carefully designed and tested for RedM. From player management to horse equipment customization, from Discord-integrated reports to permission management — DB-Admin gives staff everything they need to run a server, all in one beautifully crafted interface.

---

## 🎨 Features at a Glance

<table>
  <tr>
    <td width="50%" valign="top">

### 🧍 **Self Actions**
- Teleport to map waypoint
- Self-revive
- Toggle invisibility
- God mode toggle
- NoClip (txAdmin integration)
- Toggle player IDs (stays open)
- Toggle player blips (stays open)

### 👥 **Player Management**
- View detailed player info
- Searchable item giver
- View inventory
- Teleport to player / bring player
- Freeze / unfreeze
- Spectate mode
- Kick with reason
- Ban (permanent or timed: 1h → 1y → max)

### 📋 **Reports System**
- `/report` command for players
- Bug / Player / Question categories
- Auto-captures nearby players
- Discord webhook integration
- Role mention support
- Claim / unclaim / resolve / close
- Staff notes per report
- Filter by status (open/claimed/resolved/closed)
- Teleport to report location
- Full SQL persistence

### 💰 **Finances**
- Add / remove cash
- Add / remove bank money
- Per-player searchable list
- Full action logging

   </td>
   <td width="50%" valign="top">

### 🛠️ **Developer Tools**
- Coordinate copy (Vector1, 2, 3, 4, Heading)
- One-click clipboard support
- Entity hash viewer (overlay)
- Door ID overlay (configurable)
- Animal Spawner (28+ animals)
- **Horse Manager** with cinematic spawn
- **Wagon Spawner** with attachment editor

### 🐴 **Horse Manager**
- 16 verified horse breeds
- Spawns 50m away & gallops to you
- Anti-flee guard (won't run from owner)
- Equip 137 saddles
- 65 blankets · 30 bedrolls · 14 horns
- Manes · tails · masks · mustaches
- Stirrups · saddlebags
- Tame & invincible by default

### 🛒 **Wagon Spawner**
- 17 wagons & carts (verified RedM models)
- Attach props to component slots
- Front box · rear box · sides
- Crates · barrels · hay · lanterns · coffins
- Edit any wagon (spawned or nearby)
- Enter driver seat instantly

### 🌦️ **Server Controls**
- Weathersync integration
- One-click weather panel access

### 🤪 **Troll** *(permission-gated)*
- Send wild animals at a player
- Set player on fire
- Permission-isolated from regular admins

### 📢 **Announcements**
- Custom server-wide messages
- 5 pre-built quick templates
- Private direct messages
- Color-coded types (info/warning/alert/success)
- On-screen banner display
- 25-message history
- Discord webhook logging

### 🔑 **Permissions Manager**
- Grant / revoke ACE permissions in-game
- Group assignments (admin/mod/dev/support)
- Per-permission grant
- View all granted perms across server
- **Auto-restores on player rejoin**
- Confirmation dialogs for safety

   </td>
  </tr>
</table>

---

## 🎭 The UI

DB-Admin features a **fully custom NUI** (no ox_lib dependency for menus) built from the ground up to match a 1899 Western aesthetic:

- 🪵 **Dark wood paneling** with subtle grain texture
- 🔱 **Brass corner brackets** & rivets
- 📜 **"Authority of the Frontier"** italic subtitle
- ⭐ **Rank badge** display
- 🎯 **Two-column responsive grid** layout
- 🔥 **Heat-branded typography** (Rye font for titles)
- 🟫 **Searchable lists** with live filtering
- 📝 **Custom forms** (text, number, select, textarea)
- ✅ **Color-coded items** (success / danger)
- 🎬 **Smooth animations** throughout
- 🗝️ **Keyboard hints** with styled key indicators

---

## 📦 Installation

### Prerequisites

| Resource | Required | Purpose |
|----------|:--------:|---------|
| [`rsg-core`](https://github.com/Rexshack-RedM/rsg-core) | ✅ | Framework |
| [`ox_lib`](https://github.com/overextended/ox_lib) | ✅ | Notifications & dialogs |
| [`oxmysql`](https://github.com/overextended/oxmysql) | ✅ | Database |
| [`weathersync`](https://github.com/Cfx-Redm-Scripts-Collection/weathersync) | ✅ | Weather control |

### Step 1 — Drop the resource

Place the `db-admin` folder in your `resources/[admin]/` directory (or wherever you keep admin resources).

### Step 2 — Run the SQL

Execute `sql/install.sql` in your database. This creates six tables:

```sql
dbadmin_reports         -- Report submissions
dbadmin_report_notes    -- Staff notes on reports
dbadmin_bans            -- Persistent ban records
dbadmin_logs            -- Full action audit log
dbadmin_announcements   -- Announcement history
dbadmin_permissions     -- Persistent in-game granted perms
```

### Step 3 — Add to `server.cfg`

```cfg
ensure oxmysql
ensure ox_lib
ensure rsg-core
ensure weathersync
ensure db-admin

# ──────────────────────────────────────────
# Permission ACE definitions
# ──────────────────────────────────────────
add_ace group.admin dbadmin.admin allow
add_ace group.admin dbadmin.moderator allow
add_ace group.admin dbadmin.developer allow
add_ace group.admin dbadmin.troll allow
add_ace group.admin dbadmin.reports allow
add_ace group.admin dbadmin.finances allow

# Add yourself to group.admin
add_principal identifier.license:YOUR_LICENSE_HERE group.admin
```

> 💡 **Tip:** To find your license, type in F8 console while in-game:
> `print(GetPlayerIdentifiers(GetPlayerServerId(PlayerId()))[1])`

### Step 4 — Configure

Open `config.lua` and set:
- Discord webhook URLs (optional)
- Discord role IDs to mention (optional)
- Report cooldown & nearby distance
- Announcement templates
- Available horses, wagons, equipment

### Step 5 — Restart

```
restart db-admin
```

Press **`PageUp`** or type **`/admin`** to open the menu!

---

## ⚙️ Configuration

### Permissions System

Permissions are tiered — assigning a higher tier inherits lower abilities:

| Permission | Grants Access To |
|------------|------------------|
| `dbadmin.admin` | **Full access** to everything |
| `dbadmin.moderator` | Player Actions, Reports, Announcements |
| `dbadmin.developer` | Developer Tools, Coordinates, Spawners |
| `dbadmin.reports` | Reports system only |
| `dbadmin.finances` | Money management only |
| `dbadmin.troll` | Troll actions only |

### Key Config Options

```lua
Config.OpenCommand        = 'admin'              -- /admin command
Config.OpenKey            = 'PGUP'               -- Keybind
Config.EnablePlayerBlips  = true                 -- Map player blips
Config.HorseSpawnDistance = 50.0                 -- Horse spawn distance (m)
Config.DefaultHorseSaddle = 0xAD4A6355           -- Default saddle on spawn

-- Reports
Config.Reports.NearbyDistance = 50.0             -- Auto-capture players within (m)
Config.Reports.Cooldown       = 60               -- Seconds between reports
Config.Reports.Webhooks.Main  = 'YOUR_URL'       -- Discord webhook

-- Discord role pings
Config.Reports.Discord.RolesToMention = {
    'YOUR_DISCORD_ROLE_ID',
}
```

---

## 🔧 Commands

| Command | Description | Permission |
|---------|-------------|------------|
| `/admin` | Open the admin menu | Any DB-Admin perm |
| `/report` | Submit a player report | All players |

> 🎮 **Default keybind:** `PageUp` opens the admin menu (configurable).

---

## 🗄️ Database Schema

DB-Admin uses six tables for full persistence:

<details>
<summary><b>Click to view schema</b></summary>

#### `dbadmin_reports`
Stores all player-submitted reports with status, claimer, and metadata.

#### `dbadmin_report_notes`
Staff notes on each report (foreign-keyed to reports).

#### `dbadmin_bans`
Persistent ban records with auto-expiry on connect.

#### `dbadmin_logs`
Full audit log of every admin action with admin name, target, and details.

#### `dbadmin_announcements`
Announcement history (last 25 displayed in UI).

#### `dbadmin_permissions`
Permissions granted in-game — auto-restored when granted players reconnect.

</details>

---

## 🌐 Discord Integration

DB-Admin sends rich embeds to Discord webhooks for:

- 📋 **New reports** (with category, reporter, location, message, nearby players)
- 🔄 **Report status changes** (claim, resolve, close)
- 📢 **Announcements** (info/warning/alert/success types)

Each embed is color-coded and includes timestamps, footer branding, and optional role mentions.

---

## 🛡️ Security & Logging

- ✅ **Server-side permission checks** on every action
- ✅ **Cannot spoof admin events** from client
- ✅ **Full audit log** of every admin action saved to DB
- ✅ **Ban check on connect** — auto-expires temporary bans
- ✅ **Permission auto-restore** — granted perms persist across restarts

---

## 🎯 Design Philosophy

> *"Build it like a saddle. Make it last, make it beautiful, and make it feel earned."*

Every feature in DB-Admin was built around three principles:

1. **Comprehensive** — One menu for everything an admin needs
2. **Visually distinct** — A theme that matches RedM, not generic black-and-blue
3. **Performant** — Custom NUI with no React/Vue overhead, minimal threads

---

## 🔄 Version History

### v2.0.0 — *"Authority of the Frontier"*
- 🎨 Complete UI overhaul — custom NUI with Western theme
- 🐴 Horse Manager with cinematic spawn (50m + gallop)
- 🛒 Wagon Spawner with component editor
- 🔍 Searchable lists everywhere
- 📝 Custom NUI forms (replaces ox_lib dialogs)
- 🔑 Permissions UI with auto-restore
- 📢 Full announcements system
- ✅ All menus converted to native NUI

### v1.0.0
- Initial release with ox_lib menus
- Player management, reports, finances, dev tools
- Discord webhook support

---

## 🤝 Credits

Built with care for the RedM community.

**Dependencies:**
- [RSG Core](https://github.com/Rexshack-RedM/rsg-core) — Framework
- [ox_lib](https://github.com/overextended/ox_lib) — Notifications & dialogs
- [oxmysql](https://github.com/overextended/oxmysql) — Database
- [weathersync](https://github.com/Cfx-Redm-Scripts-Collection/weathersync) — Weather

**Fonts:**
- [Rye](https://fonts.google.com/specimen/Rye) — Wild West display
- [Cinzel](https://fonts.google.com/specimen/Cinzel) — Roman serif
- [IM Fell English](https://fonts.google.com/specimen/IM+Fell+English) — Period-correct serif

---

## 📜 License

MIT License — Use it, modify it, share it. Just don't sell it pretending it's yours.

---

<div align="center">

### *"Authority of the Frontier"*

**DB-Admin** · Diamondback Scripts · All Rights Reserved

[Report Bug](https://github.com) · [Request Feature](https://github.com) · [Documentation](https://github.com)

</div>
