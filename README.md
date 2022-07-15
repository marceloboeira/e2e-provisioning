# e2e-provisioning

This is an example of how terraform can be used for end-to-end provisioning, not only of "logical" resources but also for full integration with other parts of the process, e.g.: Infrastructure, Service Discovery, Monitoring, Paging...

It is important to understand that this type of provisioning is not focus on delivering "applications" yet peripherical and sorrounding infrastructured used by applications, e.g.: databases, caches, queues, loadbalacers, clusters rather than "containers". Containers or any sort of app deployment mechanism (e.g.: binary deployment, code-replacement, lambda functions) should live outside terraform as [terraform is not a deployment tool](dont-deploy-with-terraform).

To illustrate the example an example company is using:

* AWS Resources, e.g.: "RDS", "ElastiCache" - All terraform resources for AWS are using a mocked resource (null_resource) to facilitate this playground environment
* Consul for Service Discovery - All AWS-created resources are registered on consul for service discovery from the application side
* ...

## Distributed ownership, centralized controls

End-to-end Provisioning is extremely coupled with company culture, not all provisioning methods work with all company structures. This specific approach tends to work better with a [YBIYRI](ybiyri) strategy. It is important to highligh which roles/teams are expected to have be around:

* **platform-providers** - Engineers working on ensuring modules and mechanisms around
  * Platform engineers are expected own the processes, documentation and communicatin of infra-offerings rather than owning the infra itself. They create, maintain and document offerings for things such as: Databases, Cache, Serverless Components, LoadBalancers, CDNs...
  * Platform engineers review Pull-requests from service-owners and ensure quality controls continue to be in-place for all new infra created, either by simply code-review or building more robust controlling mechanisms to automate aways common problems
  * **example roles**: Infra Engineers, Database Engineers, Network Engineers, SREs, ...
  * **example interactions**:
    * "database engineer creates a new engine module for provisioning Amazon Aurora"
    * "database engineer makes it possible to upgrade Postgres versions to 14.2"
    * "infra engineer fixes a bug on all MySQL backups"
    * "SRE creates a new SLO monitor for all ElastiCache instances"
    * "SRE enables default MultiAZ read-replicas for all production Postgres instances"
    * "platform engineer reviews pull-requests from product to add a new Postgres cluster"
* **service-owners** - Engineers working on their services/applications which require peripherical infrastructure
  * Service owners are expected to also own their infrastructure, using everything platform creates, reading internal documentation and being aware of all oferings.
  * **example roles**: Back-end Engineers, Front-end Engineers, SREs, ...
  * **example interactions**:
    * "finance engineer creates a new Database"
    * "front-end engineer updates Loadbalancer Headers"
    * "customer acquisition engineer creates a pull-request to increase cache memory"
    * "support engineer creates a pull-request to change backup configuration of a database"

## Makefile

```
apply             Run terraform apply
compose           Start all dependencies via docker
format            Format the code
help              List help commands
init              Lock all terraform projects dependencies
install_terraform Install terraform version with tfenv
plan              Run terraform plan
setup             Install all dependencies
```

### File structure

```
├── Makefile  - Overall commands
├── README.md - Documentation
├── docker-compose.yml - Dependencies docker
├── accounts
│   ├── production -> Production resources
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   └── versions.tf
│   └── staging -> Staging resources
│       ├── main.tf
│       ├── providers.tf
│       └── versions.tf
└── modules
    ├── aws -> AWS related modules
    │   ├── elasticache -> A module to create ElastiCache Clusters
    │   └── rds -> A module to create RDS Clusters
    ├── consul -> Consul related modules
    │   ├── node -> A module to create consul nodes
    │   └── service -> A module to create consul services
    └── platform -> "Platform" modules
        ├── cache -> A module to create a full end-to-end cache
        └── database -> A module to create a full end-to-end database
```

* accounts - There are individual "accounts", those can be any isolation level you want to set but usually represent "orgs" and/or "environments"
  * e.g.: "platform-production", "platform-staging", "payments-production",...
  * For simplicity here only production/staging is used
  * Each folder is its own terraform project for state isolation purposes
* modules -> contain both generic modules for external providers as much as "platform" modules, which are mostly an end-to-end combination of the otheres to setup everything related to that resource

[ybiyri]: https://www.equalexperts.com/blog/our-thinking/what-is-you-build-it-you-run-it/
[dont-deploy-with-terraform]: https://medium.com/google-cloud/dont-deploy-applications-with-terraform-2f4508a45987
