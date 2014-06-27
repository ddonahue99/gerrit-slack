# Gerrit integration for Slack

## What is it?

A daemon that sends updates to Slack channels as noteworthy events happen on Gerrit:

  * Passing builds (except WIPs)
  * Code/QA/Product reviews
  * Comments
  * Merges
  * Failed builds (sent to owner via slackbot DM)

## Configuration

Sample configuration files are provided in `config`.

### slack.yml

Configure your team name and Incoming Webhook integration token here.

### gerrit.yml

Set the SSH command used to monitor stream-events on gerrit.

### channels.yml

This is where the real fun happens. The structure is as follows:

    channel1:
      project:
        - project1*

    channel2:
      project:
        - project2*
        - project3
      owner:
        - owner1
        - owner2
        - owner3

This configuration would post **all** updates from project1 to channel1, likewise for project2 and channel2. Updates to project3 are only posted to channel2 if the change owner is among those listed.

### aliases.yml

In order to ping a user on slack (e.g. for DMs on failed builds, or to @mention them), we need to know their Slack username. By default we assume the gerrit name is equal to the slack name. You can override this behavior on a per-user basis in aliases.yml.

## Running the daemon

    bundle install
    bin/gerrit-slack

## Running tests

    rspec
