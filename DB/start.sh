#!/bin/bash

riak/bin/riak start
mongod --dbpath mongo/db --rest --fork --logpath mongo/mongo.log
redis-server redis.conf
