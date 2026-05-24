#!/usr/bin/env python3
"""Git sync for Bloom Learning vaults — pull before session, push after."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


def find_git_root(path: Path) -> Path | None:
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            capture_output=True, text=True, cwd=path,
        )
        if result.returncode == 0:
            return Path(result.stdout.strip())
        return None
    except (OSError, subprocess.SubprocessError):
        return None


def _has_remote(git_root: Path) -> bool:
    try:
        result = subprocess.run(
            ["git", "remote"],
            capture_output=True, text=True, cwd=git_root,
        )
        return result.returncode == 0 and bool(result.stdout.strip())
    except (OSError, subprocess.SubprocessError):
        return False


def _run(cmd: list[str], cwd: Path) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, capture_output=True, text=True, cwd=cwd)


def pull(topic_path: Path) -> int:
    """Pull latest from remote. Returns 0 on success, non-zero on skip/warning."""
    git_root = find_git_root(topic_path)
    if git_root is None:
        return 0

    if not _has_remote(git_root):
        return 0

    # Stash local changes if any, so pull can proceed cleanly
    status = _run(["git", "status", "--porcelain"], cwd=git_root)
    stashed = False
    if status.stdout.strip():
        print("[sync] Stashing local changes before pull...")
        _run(["git", "stash", "--include-untracked"], cwd=git_root)
        stashed = True

    result = _run(["git", "pull", "--rebase"], cwd=git_root)
    if result.returncode != 0:
        print(f"[sync] Warning: git pull failed:\n{result.stderr}", file=sys.stderr)
        if stashed:
            print("[sync] Restoring stashed changes...")
            _run(["git", "stash", "pop"], cwd=git_root)
        return 1

    if result.stdout.strip():
        print(result.stdout.strip())

    if stashed:
        print("[sync] Restoring stashed changes...")
        pop = _run(["git", "stash", "pop"], cwd=git_root)
        if pop.returncode != 0:
            print(f"[sync] Warning: stash pop had conflicts. Resolve manually.\n{pop.stderr}", file=sys.stderr)

    print("[sync] Pull complete.")
    return 0


def push(topic_path: Path, message: str) -> int:
    """Stage all, commit, and push. Returns 0 on success, non-zero on skip/warning."""
    git_root = find_git_root(topic_path)
    if git_root is None:
        return 0

    if not _has_remote(git_root):
        return 0

    status = _run(["git", "status", "--porcelain"], cwd=git_root)
    if not status.stdout.strip():
        print("[sync] Nothing to commit.")
        return 0

    print("[sync] Changes to commit:")
    for line in status.stdout.strip().splitlines():
        print(f"  {line}")

    add = _run(["git", "add", "-A"], cwd=git_root)
    if add.returncode != 0:
        print(f"[sync] Warning: git add failed:\n{add.stderr}", file=sys.stderr)
        return 1

    commit = _run(["git", "commit", "-m", message], cwd=git_root)
    if commit.returncode != 0:
        print(f"[sync] Warning: git commit failed:\n{commit.stderr}", file=sys.stderr)
        return 1
    print(commit.stdout.strip())

    push_result = _run(["git", "push"], cwd=git_root)
    if push_result.returncode != 0:
        print(f"[sync] Warning: git push failed (files saved locally):\n{push_result.stderr}", file=sys.stderr)
        return 1
    print(push_result.stdout.strip())
    print("[sync] Push complete.")
    return 0


def setup_remote(topic_path: Path, remote_url: str) -> int:
    """Configure or update the origin remote for the vault's git repo."""
    git_root = find_git_root(topic_path)
    if git_root is None:
        print("Error: not a git repository. Run 'git init' first.", file=sys.stderr)
        return 1

    result = _run(["git", "remote", "add", "origin", remote_url], cwd=git_root)
    if result.returncode != 0:
        stderr = result.stderr.strip()
        if "already exists" in stderr:
            _run(["git", "remote", "set-url", "origin", remote_url], cwd=git_root)
            print(f"Remote 'origin' updated → {remote_url}")
        else:
            print(f"Error: {stderr}", file=sys.stderr)
            return 1
    else:
        print(f"Remote 'origin' set → {remote_url}")
    return 0


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description="Git sync for Bloom Learning vaults")
    sub = parser.add_subparsers(dest="command", required=True)

    p_pull = sub.add_parser("pull", help="Pull latest changes from remote")
    p_pull.add_argument("topic_path", help="Path to the topic directory")

    p_push = sub.add_parser("push", help="Stage all, commit, and push")
    p_push.add_argument("topic_path", help="Path to the topic directory")
    p_push.add_argument("-m", "--message", required=True, help="Commit message")

    p_setup = sub.add_parser("setup", help="Configure git remote for a vault")
    p_setup.add_argument("topic_path", help="Path to the topic directory")
    p_setup.add_argument("remote_url", help="Git remote URL (SSH or HTTPS)")

    args = parser.parse_args()
    topic_path = Path(args.topic_path)

    if args.command == "pull":
        sys.exit(pull(topic_path))
    elif args.command == "push":
        sys.exit(push(topic_path, args.message))
    elif args.command == "setup":
        sys.exit(setup_remote(topic_path, args.remote_url))


if __name__ == "__main__":
    main()
