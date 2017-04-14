## Docker image for installing lookup-srv in kubernetes pods

The docker image has [lookup-srv](https://github.com/ochko/lookup-srv) installed at `/usr/local/bin/lookup-srv`.

Useful for kubernetes StatufulSet's [pod initialization](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-initialization/).

It copies `lookup-srv` into directory specified by `--work-dir` arg.

Here is an example illustrating mongodb replica set with 2 initContainers:

 - First init container copies `lookup-srv` into `/work-dir`
 - Second init container uses `mongo` image, initializes replica set
 - Main container uses config and data prepared by the init contaiers

```yaml
apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: mongo
spec:
  serviceName: mongo-rs
  replicas: 3
  template:
    metadata:
      labels:
        app: mongo-rs
    spec:
      initContainers:
        - name: install-lookup-srv
          image: reallyenglish/k8s-init:0.2.0
          args: ["--work-dir=/work-dir"]
          volumeMounts:
            - mountPath: /work-dir
              name: workdir
        - name: init-replset
          image: mongo:3.4
          command:
            - "bash"
            - "-c"
            - |
              # use /work-dir/lookup-srv in the initialization script
              # write to /config/mongod.conf, and/or create db in /data/db
              # ...

          volumeMounts:
            - mountPath: /data/db
              name: data
            - mountPath: /config
              name: config
            - mountPath: /work-dir
              name: workdir

      containers:
        - name: server
          image: mongo:3.4
          command:
            - /usr/bin/mongod
            - --config=/config/mongod.conf
          ports:
            - name: mongo
              containerPort: 27017
              protocol: "TCP"
          volumeMounts:
            - mountPath: /data/db
              name: data
            - mountPath: /config
              name: config

      volumes:
      - name: config
        configMap:
          name: mongo-config
          items:
            - key: mongod-dot-conf
              path: mongod.conf
      - name: workdir
        emptyDir: {}

  volumeClaimTemplates:
  - metadata:
      name: data
      annotations:
        volume.alpha.kubernetes.io/storage-class: anything
    spec:
      accessModes:
        - "ReadWriteOnce"
      resources:
        requests:
          storage: 10Gi
```
