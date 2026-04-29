# Semantic — VPS & Infrastructure

Technical knowledge about Hostinger VPS and related infrastructure issues.

---

## Hostinger VPS (72.60.119.23)

**Host OS:** Debian 13 (trixie)
**Network:** IPv4 72.60.119.23, port 22 (SSH) reachable externally
**Resources:** ~14GB RAM available, ~178GB free disk
**Package manager:** apt (configured to redirect to Homebrew)
**Root password:** blank/empty

### SSH Configuration (2026-04-28 01:32–02:59 EDT)

**Status:** ⚠️ PARTIAL — localhost works, external IP fails consistently

**ED25519 Keypair:**
- Generated: 2026-04-28
- Private: /data/.ssh/id_ed25519 (container)
- Public: /root/.ssh/authorized_keys (VPS)
- Permissions: 0600 verified
- Fingerprint: SHA256:Q7BF4pb5baks9Iq0KNloeoEoPWWlQiYvpTR3NyMfE+8

**Connectivity:**
- ✅ Localhost (127.0.0.1): Authenticates successfully via ED25519
- ❌ External IP (72.60.119.23): Consistently fails "Permission denied (publickey)" despite key match and port reachability

**Suspected root cause:**
- Docker networking isolation (container sshd ≠ host sshd)
- OR two conflicting sshd instances:
  - /home/linuxbrew/.linuxbrew/sbin/sshd
  - /data/linuxbrew/.linuxbrew/sbin/sshd
- sshd config updated multiple times to 0.0.0.0 and restarted; issue persists

**Action required:**
- User to test SSH from Windows (C:\Users\r\.ssh\id_ed25519) to 72.60.119.23
- This will isolate whether issue is container-internal networking vs. broader VPS/external routing problem

### Ollama Access (Verified 2026-04-27 23:42–23:45 EDT)

✅ SSH access to container successful via localhost
✅ Ollama container operational: qwen2.5:7b (4.7GB, modified 11h prior) + qwen3.5:9b both present
✅ Inference tests passed (~1s simple, ~3s complex latency)
✅ API responsive at localhost:11434

---

## Known issues

1. **SSH external connectivity:** Possible Docker/networking isolation preventing external key auth
2. **Homebrew on VPS:** Non-standard setup (Debian → Homebrew redirection); may cause compatibility issues

---

## Next steps

- Get G to test SSH from Windows workstation to isolate root cause
- Consider alternative auth methods (password, agent forwarding) as temporary workaround
- If Docker isolation confirmed, may need network bridge reconfiguration
