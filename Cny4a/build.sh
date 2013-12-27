#!/bin/bash
set -e
ant start_ts
ant emma debug install test
ant stop_ts