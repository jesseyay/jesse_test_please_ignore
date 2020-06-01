FROM alpine

ENV TERRAFORM_VERSION=0.12.24

RUN apk update && apk add curl git python3 py-pip

# Install terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  chmod +x ./terraform && \
  mv ./terraform /usr/local/bin/terraform && \
  rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Copy deploy script onto the PATH and make executable
COPY deploy-terraform /usr/local/bin/deploy-terraform
RUN chmod +x /usr/local/bin/deploy-terraform

# Allow github access through GITHUB_TOKEN evironment variable
RUN git config --global credential.helper \
  '!f() { sleep 0.1; echo "username=${GITHUB_TOKEN}"; echo "password=x-oauth-basic"; }; f'
