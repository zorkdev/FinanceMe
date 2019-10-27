#!/bin/sh

cat > $XCS_PRIMARY_REPO_DIR/config.json << EOF
{
    "email": "$TEST_USER_EMAIL",
    "password": "$TEST_USER_PW"
}
EOF
