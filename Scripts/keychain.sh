#!/bin/sh

security unlock -p $LOCAL_PW ~/Library/Keychains/login.keychain
security unlock -p $LOCAL_PW ~/Library/Keychains/login.keychain-db
