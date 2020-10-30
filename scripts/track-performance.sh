#!/bin/bash

if [[ $# -ne 1 ]] ; then
  echo "First argument should be a metric type (benchmark, binarysize, testcoverage)"
  exit 1
fi

if [[ $CIRCLE_BRANCH == master ]]; then
  publishResults=true
else
  publishResults=false
fi

if [[ -n "${MOBILE_METRICS_TOKEN}" ]]; then
  echo $1
  if [[ $1 == "benchmark" ]]; then
    echo "run benchmark, publish results: $publishResults"
    curl -u ${MOBILE_METRICS_TOKEN}: \
      -d run_android_navigation_benchmark=$publishResults \
      -d build_parameters[CIRCLE_JOB]=android-navigation-benchmark \
      -d build_parameters[BENCHMARK_COMMIT]=${CIRCLE_SHA1} \
      https://circleci.com/api/v1.1/project/github/mapbox/mobile-metrics/tree/km-refactor-navigation-trigger
  fi

  # TODO strip out the --dry run parameter requirement from mobile-metrics/android-binary-analyzer.py
  if [[ $1 == "binarysize" ]]; then
    if $publishResults ; then
      echo "run binarysize, publish results: true"
      curl -u ${MOBILE_METRICS_TOKEN}: \
        -d build_parameters[CIRCLE_JOB]=android-navigation-binary-size \
        -d build_parameters[BENCHMARK_COMMIT]=${CIRCLE_SHA1} \
        https://circleci.com/api/v1.1/project/github/mapbox/mobile-metrics/tree/km-refactor-navigation-trigger
    else
      echo "run binarysize, publish results: false"
      curl -u ${MOBILE_METRICS_TOKEN}: \
        -d build_parameters[CIRCLE_JOB]=android-navigation-binary-size-ci \
        -d build_parameters[BENCHMARK_COMMIT]=${CIRCLE_SHA1} \
        https://circleci.com/api/v1.1/project/github/mapbox/mobile-metrics/tree/km-refactor-navigation-trigger
    fi
  fi

  # TODO strip out the --dry run parameter requirement from mobile-metrics/parse-code-coverage.py
  if [[ $1 == "testcoverage" ]]; then
    if $publishResults ; then
      echo "run testcoverage, publish results: true"
      curl -u ${MOBILE_METRICS_TOKEN}: \
        -d build_parameters[CIRCLE_JOB]=android-navigation-code-coverage \
        -d build_parameters[BENCHMARK_COMMIT]=${CIRCLE_SHA1} \
        https://circleci.com/api/v1.1/project/github/mapbox/mobile-metrics/tree/km-refactor-navigation-trigger
    else
      echo "run testcoverage, publish results: false"
      curl -u ${MOBILE_METRICS_TOKEN}: \
        -d build_parameters[CIRCLE_JOB]=android-navigation-code-coverage-ci \
        -d build_parameters[BENCHMARK_COMMIT]=${CIRCLE_SHA1} \
        https://circleci.com/api/v1.1/project/github/mapbox/mobile-metrics/tree/km-refactor-navigation-trigger
    fi
  fi
fi
