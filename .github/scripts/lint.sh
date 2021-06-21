#!/bin/bash

# NOTE:
#   --validate-chart-schema=false due to https://github.com/helm/chart-testing/pull/300

ct lint \
    --chart-dirs ${CHARTS_DIR} \
    --all \
    --validate-maintainers=false
