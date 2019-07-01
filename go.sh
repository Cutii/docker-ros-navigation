#!/bin/sh

# Get the id of the runner (if exists)
id=$(curl --header \
  "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" \
  "$GITLAB_INSTANCE/api/v4/runners" | python3 -c \
'
import sys, json;
json_data=json.load(sys.stdin)
for item in json_data:
  if item["description"] == "'$RUNNER_NAME'":
    print(item["id"])
')

echo "👋 id of $RUNNER_NAME runner is: $id"

echo "⚠️ trying to deactivate runner..."

curl --request DELETE --header \
  "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" \
  "$GITLAB_INSTANCE/api/v4/runners/$id"

#Copy private and public ssh key to give access to Gitlab
cp $SSH_PRIVATE_KEY /root/.ssh
cp $SSH_PUBLIC_KEY /root/.ssh

# Register, then run the new runner
echo "👋 launching new gitlab-runner"

gitlab-runner register --non-interactive \
  --url "$GITLAB_INSTANCE/" \
  --name $RUNNER_NAME \
  --registration-token $TOKEN \
  --executor shell

gitlab-runner run &

echo "🌍 executing the http server"
http-server -p 8080