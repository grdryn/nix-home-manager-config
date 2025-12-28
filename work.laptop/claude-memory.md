- Use the "Assisted-By" trailer in commit messages rather than "Co-Authored-By" trailer when attributing Claude
- Don't add the  "Generated with Claude Code" line (or any such variation) to commit messages.
- Whenever a jira issue link is provided, it should be put at the top of the git commit description, below the summary/title line
- git commit summary line should be no more than 50 characters

# Jira

## Key Field IDs for RHOAIENG Project
- **Epic Name**: `customfield_12311141` (string)
- **Epic Link**: `customfield_12311140` (issue key)
- **Team**: `customfield_12313240` (string value like "4151")
- **Component/s**: `components` (array of objects with "name" field)

Despite appearances, the proper ID for "AI Core Platform" is "4151", so if I ask to set team to "AI Core Platform", use "4151" as the value.

## Troubleshooting

### Field Update Failures
If direct field updates fail via API:
1. Create issues first
2. Use Jira bulk edit UI for field updates
3. Generate bulk edit URL: `https://issues.redhat.com/issues/?jql=key%20in%20(ISSUE-1,ISSUE-2)`
