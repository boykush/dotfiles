---
name: create-task
description: Create a new task in the shared task list. Use when asked to plan or register work.
disable-model-invocation: true
allowed-tools: Bash(mise run claude:projects)
---

Create a new task in the shared task list.

## Steps

1. Ask the user which project to use. Run `mise run claude:projects` to list candidates.
2. Ask the user what task to do. Do not ask about task type, category, or any other classification.
3. Use TaskCreate to register the task. Include the project path in the description.
