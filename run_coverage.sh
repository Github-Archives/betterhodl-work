#!/bin/bash

flutter test --coverage --dart-define=ENV=PROD
lcov -o coverage/lcov.info
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html