FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim_cloudbuild_cache as builder

ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION

WORKDIR /builder/terragrunt

RUN apt-get update
RUN apt-get -y install unzip
RUN curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_linux_amd64.zip
RUN unzip terraform_linux_amd64.zip -d /builder/terragrunt

RUN curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o terragrunt_linux_amd64


FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim_cloudbuild_cache

ENV PATH=/builder/terragrunt/:$PATH

WORKDIR /builder/terragrunt

COPY requirements.txt /builder/requirements.txt

RUN pip3 install -r /builder/requirements.txt

COPY --from=builder /builder/terragrunt/terraform ./terraform
COPY --from=builder /builder/terragrunt/terragrunt_linux_amd64 ./terragrunt

COPY post_plan.py /builder/post_plan.py
COPY entrypoint.bash /builder/entrypoint.bash

RUN chmod +x terraform terragrunt
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/builder/entrypoint.bash"]
