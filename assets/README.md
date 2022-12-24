# Provided assets

## Kibana dashboards

 The dashboards can be imported right into **Kibana Saved Objects**, following the menu:
 * Management > Kibana > Saved Objects
   - :arrow_down: Import
---

 Asset file                 | Screenshot
----------------------------|----------------------------------------------------------------
 docker-dashboard.ndjson    | ![Metrics Docker](../docs/img/dashboards/metrics.png "metrics")
 health-dashboard.ndjson    | ![Health Docker](../docs/img/dashboards/health.png "health")


---
## AWS Cloudformation

Examples to apply **Fluent-Beats** observability using [AWS ECS](https://docs.aws.amazon.com/ecs/)

- fake-service.yml: Observable **ECS task** deploy
- fluent-beatas.yml: Fluent-Beats **ECS daemon** deploy