# NOTE on mismatched chart name and folder names

## Issue
The chart names and folder names do not match.

## Reason
Had to put this in a sub folder (`ploigos-workflow`) and remove `ploigos-workflow-` from the
folder names of all of these charts due to how `chart-tester` works and helm and kubernetes
name lengths.

This was first encountered when adding `ploigos-workflow-everything-tekton-pipeline` which
put us over the character limit.

## Resolution
Can't be changed until there is some resolution to https://github.com/helm/chart-testing/issues/343.
