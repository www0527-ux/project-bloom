# Git Workflow

Default to GitHub SSH.

```powershell
git remote add origin git@github.com:username/repo.git
```

## Before Development

```powershell
git pull
git status
```

If the repository is new and has no remote branch yet, `git pull` may not apply. Inspect `git status` before editing.

## After Meaningful Progress

```powershell
git status
git add .
git commit -m "Describe this stage checkpoint"
```

Only push after explicit user confirmation:

```powershell
git push
```

## Checkpoint Rules

- Commit small, verified milestones.
- Mention the learning stage in the commit message when useful.
- Do not commit secrets, local databases, virtual environments, or generated caches.
- If tests exist, run the relevant tests before committing.
- If no tests exist, record the manual verification in Obsidian.

## SSH Remote Examples

```powershell
git remote add origin git@github.com:your-username/your-repo.git
git remote -v
```

Do not replace an existing `origin` without checking with the user.
