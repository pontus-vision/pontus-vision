#!/bin/bash

 kubectl patch deployment graphdb-nifi  -p   "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"

