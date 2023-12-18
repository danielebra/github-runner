# `ARM64` Github Runner

## Prerequisites

Since a github runner is associated to an organization, the following
are required to create a self-hosted runner

1.  Github organization
2.  Runner token

Navigate to your Organiztion settings –\> `Actions` –\> `Runners` –\>
`New runner` –\> `New self-hosted runner`

Select `Linux` and the `ARM64` architecture. This will provide you with
the `token`.

Alternatively, this can be performed via the Github API

## Setup

Set the following as envirnoment variables or store them directly in
`build.sh`

  ORGANIZATION
  TOKEN

`./build.sh` will build the runner image with name `runner`

## Start the runner

``` sh
docker run -it --rm runner
```

The `entrypoint.sh` script will automatically de-register the runner
when the container is stopped. Feel free to adjust this behaviour if it
undesired.

