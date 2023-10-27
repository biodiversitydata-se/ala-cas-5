#!/bin/sh
set -e

echo "Trying to create database and users"
if [ -n "${MONGO_INITDB_ROOT_USERNAME:-}" ] && [ -n "${MONGO_INITDB_ROOT_PASSWORD:-}" ]; then
mongosh -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase $MONGO_INITDB_DATABASE<<EOF
db=db.getSiblingDB('cas-audit-repository');
db.createUser({
  user:  'audit',
  pwd: 'audit',
  roles: [{
    role: 'readWrite',
    db: 'cas-audit-repository'
  }]
});
db=db.getSiblingDB('cas-ticket-registry');
db.createUser({
  user:  'ticket',
  pwd: 'ticket',
  roles: [{
    role: 'readWrite',
    db: 'cas-ticket-registry'
  }]
});
db=db.getSiblingDB('cas-service-registry');
db.createUser({
  user:  'service',
  pwd: 'service',
  roles: [{
    role: 'readWrite',
    db: 'cas-service-registry'
  }]
});
EOF
else
    echo "Necessary credentials  missing, hence exiting database and user creation!"
    exit 403
fi