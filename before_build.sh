#!/bin/bash

cp assets/database_module/database/database_structure.sql assets 2>/dev/null
cp assets/database_module/database/database_inserts.sql assets 2>/dev/null
cp assets/database_module/database/database.version assets 2>/dev/null
cp -r assets/database_module/localisation/* assets/localisation 2>/dev/null
