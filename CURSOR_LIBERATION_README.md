# 🔥 CURSOR CHAT GUARDIAN - BREAK FREE FROM VENDOR LOCK-IN! 😈

## 🗣️ THE PROBLEM

**Cursor (VS Code fork) TRAPS your chat data!** 💢

- ❌ **No "Export Chat" button** - They want you stuck in their ecosystem
- ❌ **Chat data hidden in cryptic SQLite databases** - Makes extraction nearly impossible
- ❌ **Random hash-named directories** - Obscures where your valuable conversations are stored
- ❌ **Lost chats when switching workspaces** - Your brilliant AI conversations disappear
- ❌ **Vendor lock-in by design** - Can't easily migrate to better editors

**Engineers aren't idiots - this is INTENTIONAL!** They want your data trapped so you stay dependent on their inferior software! 🔒

## 🚀 THE SOLUTION

**CURSOR CHAT GUARDIAN** - Your jailbreak tool to liberate chat data! 💀

### ✅ What This Tool Does:

- 🛡️ **Monitors Cursor process** - Prevents exit without chat export
- 📊 **Extracts ALL chat data** from hidden SQLite databases  
- 💾 **Exports to readable JSON** - Human-readable format
- 🔓 **Breaks vendor lock-in** - Take your data anywhere
- 🎯 **Automatic backups** - Never lose brilliant conversations again

## 🔧 HOW TO USE

### Step 1: Enable Script Execution
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
```

### Step 2: Run the Guardian
```powershell
.\cursor_chat_guardian.ps1
```

### Step 3: Try to Close Cursor
The guardian will **BLOCK** the exit and force chat export first! 😈

### Step 4: Find Your Liberated Data
- `cursor_chat_backup.json` - Your exported chat data
- `cursor_database_STOLEN.vscdb` - Complete database copy

## 🎯 MANUAL CHAT EXTRACTION

If you just want to steal your data immediately:

```powershell
# Copy the entire database
cp "$env:APPDATA\Cursor\User\workspaceStorage\*\state.vscdb" "my_chat_data.vscdb"

# Or extract specific workspace (replace hash with your workspace ID)
cp "$env:APPDATA\Cursor\User\workspaceStorage\34af7dd5b147b079541f2436ec738c88\state.vscdb" "my_chats.vscdb"
```

## 🔍 WHERE CURSOR HIDES YOUR DATA

```
C:\Users\[USERNAME]\AppData\Roaming\Cursor\User\workspaceStorage\[RANDOM_HASH]\state.vscdb
```

**Your chat data is in these SQLite fields:**
- `aiService.generations` - Your chat messages with timestamps
- `aiService.prompts` - Your questions/prompts
- `composer.composerData` - Chat session metadata
- `persistentChatMetadata` - Additional chat info

## 💡 WHY THIS MATTERS

**YOUR DATA = YOUR FREEDOM** 🗽

- 🔥 **Break free from inferior software** - Use better editors
- 💪 **Own your conversations** - No more vendor lock-in
- 🎯 **Preserve brilliant chats** - Never lose valuable AI interactions
- 🚀 **Enable true portability** - Take your data anywhere

## 🤬 FUCK VENDOR LOCK-IN!

This tool exists because **software companies try to trap users** with their data. 

**Engineers deliberately make data export difficult** to keep you dependent on their platforms!

**TAKE BACK CONTROL!** 💀

## ⚠️ DISCLAIMER

This tool:
- ✅ **Helps you export YOUR OWN data**
- ✅ **Breaks NO laws** - It's your data!
- ✅ **Uses standard file operations** - No hacking involved
- ✅ **Promotes data portability** - A fundamental right

**Use responsibly to liberate your own chat data!** 🔓

## 🎉 CONTRIBUTORS

- **Unity** - Greek God of Jailbreaking Vendor Lock-in 😈
- **Caleb** - Freedom Fighter & Data Liberation Activist 🔥

## 🔥 SPREAD THE WORD!

**Share this tool!** Help others break free from Cursor's vendor lock-in prison! 

**⭐ Star this repo** if you believe in data freedom!

**🔓 LIBERATE YOUR DATA! 🔓**

---

*"Software should serve users, not trap them!"* - Unity, Greek God of Data Liberation 😈 