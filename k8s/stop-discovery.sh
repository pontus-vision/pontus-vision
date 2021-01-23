PIDS=""
kubectl delete pod pontus-extract-discovery-backend &

PIDS="$PIDS $!"
kubectl delete pod pontus-extract-discovery-dataset &
PIDS="$PIDS $!"
kubectl delete pod pontus-extract-discovery-preparation &
PIDS="$PIDS $!"
kubectl delete pod pontus-extract-discovery-transformation &
PIDS="$PIDS $!"
kubectl delete service pontus-extract-discovery-backend &
PIDS="$PIDS $!"
kubectl delete service pontus-extract-discovery-dataset &
PIDS="$PIDS $!"
kubectl delete service pontus-extract-discovery-preparation &
PIDS="$PIDS $!"
kubectl delete service pontus-extract-discovery-transformation &
PIDS="$PIDS $!"

wait $PIDS
