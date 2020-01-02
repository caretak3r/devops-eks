terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = var.region
  access_key = "ASIA4FZE7EDOKJZQKTUA"
  secret_key = "HPFgTjCmPNw9GTaThWCUM1lN/UPWX92HtJt061Mf"
  token = "IQoJb3JpZ2luX2VjEKT//////////wEaCXVzLWVhc3QtMSJHMEUCIQDbPE+4U4AmBLMAekjJFwN6G5lMyDRf451KByEtrFKgZQIgH3TlDP/6jpXfBPejnOT1hjw6mezaZ2KvPO4XTrQmSy4q/QEIHBAAGgw4MzcwNTkyODkzMDgiDEDAMy9yt4CF9goPAiraAQu3OZ6KgvNg4UUdvyWYjobSJxyOsmD1igTC2QV3cOqRjGK165BxvShf3LhO7TgDEB2kd7p6bh04SFn2N31rg/QMy5A/aNPPiBcJO1jnod73E3cqkPTocI6ZBS+11nTGGH2YzvvUFavgE1o2bIL9xCazy5r+UCziqEIMTCsDE0oJh+Lr3AwaTZ7WyNgNsvMAhTiEW6LdnHMiPUiS3wpuDWAV/kHQ3Ry1LDvemmixV9kI4MZoBV6h58j6vW5YNgpVwYnICTEX7DtRiRi37B+nfwI1kRt2H08pw+iWMMnhs/AFOukB20cWtOCmOClNuY2SwY7jRBqQ8LotwgXLr7ryJa6zozzwAhu2TU6S/BcENfXtaO9pVXtD4SLweS1fmyjf+xtc+qyAEVXEnQ/lSH2fmp4+REfG17MjnZ8WhCAi1kZqjhktxSG8bl+WdT5YZ//CPT5y+tem+K/R/pPJPc6Q1vId27TDu8qKJFRXThsoiNU092dvFzY3Xf6HPpVqYlmSgbJ0HdkS13AcXqux+Gfxz1F+VDeJSyhpNjX4cwvUxJl00j4Xk21ZboZZc39XawWdH3pUnJ2V3zlUeZC84csclGrEA4YxfYAti/sSaDc="
}

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}