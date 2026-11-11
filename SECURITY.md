# Security policy

This policy applies to every repository of the Ruchoir organization.

## Reporting a vulnerability

Report it privately, through GitHub's private vulnerability reporting, on the repository concerned:
open its **Security** tab, then **Report a vulnerability**
(`https://github.com/Ruchoir/<repository>/security/advisories/new`). If you are not sure which
repository it belongs to, choose the closest one: we move the report if needed.

This is the only channel. There is no security email address, and a vulnerability is never reported
in a public issue, a pull request, a discussion or a comment.

Please include:

- what an attacker can do, and what they need first (an account, a role, a network position);
- the repository, the version or commit, and where it runs (a service, an app, a browser);
- the steps to reproduce it, or a proof of concept;
- anything you know about a fix.

## What happens next

- We acknowledge the report in the advisory, and keep the conversation there.
- We confirm the problem, assess how serious it is, and prepare a fix in a private fork of the
  advisory.
- We publish the fix, then the advisory, with a CVE when it is warranted. Self-hosted instances get
  it through the installer, like any update.
- We credit you in the advisory, unless you prefer not to be named.

Please give us a reasonable time to ship a fix before you disclose anything.

## Supported versions

Ruchoir has not reached a first stable version yet. Fixes go into the latest release of each service,
app and package, and into nothing older.

## Scope

In scope: the code of the repositories of this organization, and the images and apps built from
them. Out of scope: the configuration of an instance you do not run (tell its administrator), and
vulnerabilities in third-party dependencies that do not affect Ruchoir (report them upstream).
