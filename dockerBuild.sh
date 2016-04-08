set -e -x

IMAGE_ROOT="$PWD/image-root"

mkdir -p /sys/fs/cgroup
mountpoint -q /sys/fs/cgroup || \
  mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup

for d in `sed -e '1d;s/\([^\t]\)\t.*$/\1/' /proc/cgroups`; do
  mkdir -p /sys/fs/cgroup/$d
  mountpoint -q /sys/fs/cgroup/$d || \
    mount -n -t cgroup -o $d cgroup /sys/fs/cgroup/$d
done

docker daemon -g /tmp/build/graph &

until docker info >/dev/null 2>&1; do
  echo waiting for docker to come up...
  sleep 1
done

docker build -t vishalmanohar/spring-petclinic -f spring-pet-clinic-repo/Dockerfile .
