import os
import sys
from datetime import datetime
from pathlib import Path
from github import Github

issue_id = int(sys.argv[1])
project_id = sys.argv[2]
github_repo = sys.argv[3]
github_user = "cato-bi-github-group"
github_token = Path("token").read_text()
terraform_full_output = Path("output").read_text()
terraform_output = (terraform_full_output[:65450] + "\nTruncated! See Cloud Build logs for full plan output.") if len(
    terraform_full_output) > 65536 else terraform_full_output
pwd = os.getcwd()
time = datetime.now()


def message_body():
    body = """
Project: {project}
Directory: {dir}
Updated at: {time}
```
{output}
```
    """.format(time=time, dir=pwd, project=project_id, output=terraform_output)
    return body


def create_or_update_comment(message):
    g = Github(github_token)
    repo = g.get_repo(github_repo)
    pull_request = repo.get_issue(issue_id)
    pr_comments = pull_request.get_comments()

    comment_id = next(
        (c.id for c in pr_comments if (c.user.login == github_user and f"Project: {project_id}\nDirectory: {pwd}" in c.body)), None)

    if comment_id is not None:
        pull_request.get_comment(comment_id).edit(message)
    else:
        pull_request.create_comment(message)


create_or_update_comment(message_body())
