# Gerrit integration for Slack

## What is it?

A daemon that sends updates to Slack channels as noteworthy events happen on Gerrit:

  * Passing builds (except WIPs)
  * Code/QA/Product reviews
  * Comments
  * Merges

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

## Running the daemon

    bundle install
    bin/gerrit-slack

## Running tests

    rspec
