#!/bin/bash
kubectl delete cronjobs.batch --all && \
kubectl delete jobs.batch --all  && \
kubectl delete deployments --all && \
kubectl delete pods --all && \
kubectl delete service --all
