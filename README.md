<!--
SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>

SPDX-License-Identifier: EUPL-1.2
-->

# common-lint

Container image and GitLab CI template providing a common set of linters used
across OpenTalk projects.

## Contents

The image is based on `alpine` and ships with the following tools:

- [`shellcheck`](https://www.shellcheck.net/) — shell script linter
- [`yamllint`](https://yamllint.readthedocs.io/) — YAML linter
- [`tombi`](https://tombi-toml.github.io/tombi/) — TOML formatter/linter
- [`markdownlint-cli2`](https://github.com/DavidAnson/markdownlint-cli2) —
  Markdown linter
- [`reuse`](https://reuse.software/) — license/copyright compliance checker
- [`commitlint`](https://commitlint.js.org/) with
  `@commitlint/config-conventional` — commit message linter
- `git` and `npm` (for invoking `npx`-based tools)

## Usage

### GitLab CI

Include the template in your project's `.gitlab-ci.yml`:

```yaml
include:
  - project: 'opentalk-tools/common-lint'
    file: '/.gitlab-ci-template.yml'
    ref: v2
```

The template defines the following jobs, all running in the `lint` stage on
merge request pipelines:

| Job              | Command                                                                  |
|------------------|--------------------------------------------------------------------------|
| `lint:shellcheck`| `git ls-files "*.sh" -z \| xargs -0r shellcheck`                         |
| `lint:yaml`      | `yamllint .`                                                             |
| `lint:toml`      | `tombi format --check`                                                   |
| `lint:markdown`  | `npx markdownlint-cli2 --warnings "**/*.md"`                             |
| `lint:licensing` | `reuse lint`                                                             |
| `lint:commit`    | `npx commitlint --from $CI_MERGE_REQUEST_DIFF_BASE_SHA --to HEAD ...`    |

Make sure your project defines a `lint` stage in its `stages:` list.

### Local use

You can also pull the image and run the tools locally:

```sh
podman run --rm -v "$PWD:/src" -w /src \
    registry.heinlein.group/opentalk-tools/common-lint:v0.1.0 \
    yamllint .
```

## Example configurations

The [example_confs/](example_confs/) directory contains baseline configuration
files used by OpenTalk projects. Copy the ones you need to your repository
root:

- [.commitlintrc.json](example_confs/.commitlintrc.json) —
  extends `@commitlint/config-conventional`
- [.markdownlint.yaml](example_confs/.markdownlint.yaml) —
  markdownlint rules
- [.yamllint.yaml](example_confs/.yamllint.yaml) —
  yamllint rules

## Building the image

```sh
podman build -t common-lint .
```

## License

Licensed under the [EUPL-1.2](https://eupl.eu/1.2/en/).
