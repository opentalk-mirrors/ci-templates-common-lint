# SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
#
# SPDX-License-Identifier: EUPL-1.2
FROM docker.io/alpine:3.23.2

RUN apk update

RUN apk add shellcheck git yamllint taplo reuse npm

RUN npm install -g @commitlint/cli @commitlint/config-conventional
RUN npm install -g markdownlint-cli2
