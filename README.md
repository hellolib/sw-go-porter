## 申威 Golang 代码移植

使用方法

```bash
./port.sh <Golang 模块路径>
```

注意，给定路径应是一个包含 go.mod 文件的合法 Golang 模块

该脚本首先下载依赖至给定路径的 vendor 目录，然后对已支持的 Package 进行移植以适配申威架构

## 支持的 Package

| Package | Status |
| :--- | :--- |
| github.com/agiledragon/gomonkey/v2 | ✅ |
| github.com/boltdb/bolt | ✅ |
| github.com/cilium/ebpf/internal | ✅ |
| github.com/containerd/containerd/contrib/seccomp | ✅ |
| github.com/containerd/containerd/platforms | ✅ |
| github.com/containerd/continuity/sysx | ✅ |
| github.com/containerd/fifo | ✅ |
| github.com/containerd/platforms | ✅ |
| github.com/containers/common/pkg/completion | ✅ |
| github.com/containers/ocicrypt/crypto/pkcs11 | ✅ |
| github.com/cockroachdb/pebble/internal/manual | ✅ |
| github.com/cockroachdb/pebble/internal/rawalloc | ✅ |
| github.com/creack/pty | ✅ |
| github.com/dgraph-io/ristretto/z | ✅ |
| github.com/docker/docker/api/types | ✅ |
| github.com/docker/docker/pkg/signal | ✅ |
| github.com/drone/drone-yaml/yaml/compiler | ✅ |
| github.com/drone/drone-yaml/yaml/linter | ✅ |
| github.com/elastic/go-concert/atomic | ✅ |
| github.com/google/cadvisor/machine | ✅ |
| github.com/go-ole/go-ole | ✅ |
| github.com/go-swagger/go-swagger/generator | ✅ |
| github.com/josharian/native | ✅ |
| github.com/klauspost/crc32 | ✅ |
| github.com/kr/pty | ✅ |
| github.com/marten-seemann/tcp | ✅ |
| github.com/mikioh/tcp | ✅ |
| github.com/minio/crc64nvme | ✅ |
| github.com/minio/madmin-go/kernel | ✅ |
| github.com/minio/madmin-go/v2/kernel | ✅ |
| github.com/minio/madmin-go/v3/kernel | ✅ |
| github.com/minio/sha256-simd | ✅ |
| github.com/moby/buildkit/client/llb | ✅ |
| github.com/moby/sys/signal | ✅ |
| github.com/opencontainers/image-spec/schema | ✅ |
| github.com/opencontainers/runc/libcontainer/seccomp | ✅ |
| github.com/opencontainers/runc/libcontainer/seccomp/patchbpf | ✅ |
| github.com/opencontainers/runc/libcontainer/system | ✅ |
| github.com/opencontainers/runtime-spec/specs-go | ✅ |
| github.com/prometheus/procfs | ✅ |
| github.com/RoaringBitmap/roaring | ✅ |
| github.com/rootless-containers/rootlesskit/pkg/sigproxy/signal | ✅ |
| github.com/seccomp/libseccomp-golang | ✅ |
| github.com/shirou/gopsutil/host | ✅ |
| github.com/shirou/gopsutil/v3/host | ✅ |
| github.com/sylabs/sif/pkg/sif | ✅ |
| github.com/sylabs/sif/v2/pkg/sif | ✅ |
| github.com/tklauser/go-sysconf | ✅ |
| github.com/u-root/uio/ubinary | ✅ |
| github.com/u-root/u-root/pkg/ubinary | ✅ |
| github.com/valyala/fasthttp | ✅ |
| github.com/valyala/gozstd | ✅ |
| github.com/vishvananda/netns | ✅ |
| go.etcd.io/bbolt | ✅ |
| golang.org/x/net/internal/socket | ✅ |
| golang.org/x/net/ipv4 | ✅ |
| golang.org/x/net/ipv6 | ✅ |
| golang.org/x/sys/cpu | ✅ |
| golang.org/x/sys/unix | Not Fully Supported |
| go.opentelemetry.io/otel/semconv | ✅ |
| go.starlark.net/starlark | ✅ |
| modernc.org/cc | TODO |
| modernc.org/libc | TODO |
| modernc.org/memory | ✅ |
