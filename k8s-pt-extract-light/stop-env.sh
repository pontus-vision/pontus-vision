#!/bin/bash
kubectl delete deployments --all && kubectl delete pods --all && kubectl delete service --all && kubectl delete jobs.batch --all && kubectl delete cronjobs.batch --all
