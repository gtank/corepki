.PHONY: ca req clean etcd k8s cfssl tarballs

CFSSL	= @env PATH=$(GOPATH)/bin:$(PATH) cfssl
JSON	= env PATH=$(GOPATH)/bin:$(PATH) cfssljson

all:

cfssl:
	go get -u github.com/cloudflare/cfssl/cmd/cfssl
	go get -u github.com/cloudflare/cfssl/cmd/cfssljson

ca:
	mkdir -p certs
	$(CFSSL) gencert -initca config/ca-csr.json | $(JSON) -bare certs/ca

etcd:
	@echo Generating etcd certs...
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/etcd/etcd-csr.json | $(JSON) -bare certs/etcd1
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/etcd/etcd-csr.json | $(JSON) -bare certs/etcd2
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/etcd/etcd-csr.json | $(JSON) -bare certs/etcd3
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/etcd/etcd-csr.json | $(JSON) -bare certs/proxy1

k8s:
	@echo Generating admin cert...
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/k8s/admin.json | $(JSON) -bare certs/admin
	@echo Generating apiserver cert...
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/k8s/apiserver.json | $(JSON) -bare certs/apiserver
	@echo Generating worker cert...
	$(CFSSL) gencert \
	  -ca certs/ca.pem \
	  -ca-key certs/ca-key.pem \
	  -config config/ca-config.json \
	  config/k8s/worker.json | $(JSON) -bare certs/worker

tarballs:
	@echo Generating apiserver.tgz
	cd certs; \
	  tar czf apiserver.tgz ca.pem apiserver-key.pem apiserver.pem
	@echo Generating worker.tgz
	cd certs; \
	  tar czf worker.tgz ca.pem worker-key.pem worker.pem
	@echo Generating admin.tgz
	cd certs; \
	  tar czf admin.tgz ca.pem admin-key.pem admin.pem

clean:
	rm -rf certs

