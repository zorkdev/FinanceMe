#!/usr/bin/env sh

set -euo pipefail

cat > $XCS_PRIMARY_REPO_DIR/TestSession.json << EOF
{
    "token": "$TEST_SESSION"
}
EOF

cat > $XCS_PRIMARY_REPO_DIR/TestUser.json << EOF
{
    "email": "$TEST_USER_EMAIL",
    "password": "$TEST_USER_PW"
}
EOF
