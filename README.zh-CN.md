# project-bloom

`project-bloom` 是一个面向 **项目式编程学习** 的 Codex skill。

它不是普通项目脚手架，也不是一次性生成完整代码项目的工具。它更像一个学习型项目教练：帮助你初始化真实代码项目、创建 Obsidian 学习记录、按阶段推进开发、记录困难和技术决策、管理 Git checkpoint，并在项目成熟后整理成简历和面试表达。

## 适合谁

- 正在通过真实项目学习 FastAPI、RAG、LangGraph、Agent 或课程设计的学习者。
- 希望 Codex 带着自己一步步实现，而不是直接给出完整项目代码的开发者。
- 使用 Windows、VS Code、Codex、PowerShell、conda 和 GitHub SSH 工作流的人。

## 和 bloom-learning 的关系

`project-bloom` 受到 `bloom-learning-repo` 的启发，但定位不同。

`bloom-learning` 更偏向“学习一个知识主题”。  
`project-bloom` 更偏向“通过一个真实编程项目进行学习”。

它关注的是：

- 项目目录初始化
- Git / GitHub SSH 工作流
- 阶段式开发路线
- 学习进度记录
- blocker 和 bug 记录
- 技术决策记录
- 阶段复盘
- 简历项目描述
- 面试讲项目时的表达

## 安装

把这个目录放到 Codex 能发现的 skills 目录下：

```text
$HOME\.agents\skills\project-bloom
```

Windows 上通常可以放在：

```text
%USERPROFILE%\.agents\skills\project-bloom
```

如果 Codex 没有立刻识别，可以重启或 reload Codex。

## 在 Codex 中使用

你可以这样向 Codex 发起请求：

```text
请使用 $project-bloom 初始化一个 FastAPI RAG 学习项目
```

或者：

```text
请使用 $project-bloom 继续我当前的项目式学习会话
```

## 初始化一个项目

进入 skill 目录后运行：

```powershell
.\scripts\init-project.ps1 `
  -ProjectName "Obsidian Learn" `
  -CodePath "D:\code\your-project" `
  -VaultPath "D:\ObsidianVault" `
  -TopicName "Obsidian Study Assistant" `
  -Level "beginner" `
  -EnvName "obsidian-learn" `
  -RepoUrl "git@github.com:your-username/your-project.git" `
  -Roadmap "fastapi-rag-langgraph" `
  -InitGit
```

脚本默认不会执行 `git push`。即使传入 `-Push`，也需要再次输入 `PUSH` 才会真正推送。

## 初始化后会生成什么

代码项目中会生成：

```text
your-project/
  AGENTS.md
  README.md
  .gitignore
  app/
  tests/
  scripts/
```

Obsidian vault 中会生成：

```text
<Project Topic>/
  _meta/
    state.json
    roadmap.md
    progress.md
    review-plan.md
    repo.md
  logs/
    dev-log.md
    blockers.md
    bug-log.md
    decisions.md
  knowledge/
    concepts.md
    terms.md
    code-patterns.md
  exercises/
    practice.md
    checkpoints.md
  summaries/
    weekly-summary.md
    stage-summary.md
  resume/
    project-description.md
    interview-talking-points.md
```

## Skill 自身结构

```text
project-bloom/
  SKILL.md
  README.md
  README.zh-CN.md
  scripts/
    init-project.ps1
    update-session.ps1
    git-checkpoint.ps1
    next-task.ps1
  assets/
    AGENTS.template.md
    README.template.md
    gitignore-python.template
    state.template.json
  references/
    project-learning-method.md
    obsidian-record-schema.md
    fastapi-rag-langgraph-roadmap.md
    git-workflow.md
```

## 脚本说明

- `init-project.ps1`：初始化代码目录、模板文件、Obsidian 学习记录、可选 Git 初始化和可选确认 push。
- `update-session.ps1`：追加一次学习会话记录，并更新 `state.json`。
- `git-checkpoint.ps1`：查看 Git 状态，可选执行 commit，可选确认 push。
- `next-task.ps1`：读取 `state.json`，输出当前阶段、当前目标和下一步任务。

## 默认学习路线

默认路线见：

```text
references/fastapi-rag-langgraph-roadmap.md
```

阶段包括：

- v0：项目初始化与 FastAPI 最小应用
- v1：Notes CRUD
- v2：数据库与 SQLAlchemy
- v3：Obsidian Markdown 读取
- v4：普通关键词搜索
- v5：RAG 最小闭环
- v6：LangGraph 编排
- v7：学习 Agent 工具调用
- v8：工程化与简历整理

## 设计原则

- 不一次性生成完整项目。
- 优先让学习者自己实现核心代码。
- Codex 负责解释、拆解、给关键片段、检查和记录。
- 不越级推进。当前阶段没有跑通之前，不进入下一阶段。
- `AGENTS.md` 保持短小，只做入口规则。
- 长路线和方法论放在 `references/` 中。
- 默认使用 PowerShell、conda、GitHub SSH。
- 默认不执行 `git push`。

## 开源安全

仓库中的路径和仓库地址都应使用占位符，例如：

```text
D:\code\your-project
D:\ObsidianVault
git@github.com:your-username/your-project.git
```

真实的本机路径、Obsidian vault 路径和 GitHub 仓库地址应在运行 `init-project.ps1` 时通过参数传入，不应该硬编码进 skill 本体。

## 后续计划

- 支持用户本机私有配置文件。
- 支持更多项目路线，例如 FastAPI-only、LangGraph-only、Agent-only。
- 根据 Git diff 自动建议 commit message。
- 更智能地判断是否可以进入下一阶段。
- 根据阶段记录生成更完整的简历项目描述。

## 致谢

This project is inspired by bloom-learning-repo. It is independently designed for project-based programming learning and does not copy the original project's code or templates.
