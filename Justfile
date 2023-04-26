# places
ANSIBLE_DIR := justfile_directory() / "provision" / "ansible"
INVENTORY_FILE := ANSIBLE_DIR / "inventory" / "hosts.yml"
PLAYBOOKS_DIR := ANSIBLE_DIR / "playbooks"
KUBERNETES_DIR := justfile_directory() / "kubernetes"

# AGE key file
HOME_DIR := env_var('HOME')
SOPS_AGE_KEY_FILE := HOME_DIR / ".config" / "sops" / "age" / "keys.txt"

default:
  @just --list

install:
    ansible-playbook -i {{INVENTORY_FILE}}

reset:
    ansible-playbook {{ANSIBLE_DIR}}/reset.yml -i {{INVENTORY_FILE}}

# Verify flux meets the prerequisites
flux_verify:
    flux check --pre

test:
    cat {{SOPS_AGE_KEY_FILE}}

# Install flux
install_flux:
    kubectl apply --kustomize {{KUBERNETES_DIR}}/bootstrap

create_age_key_secret:
    cat {{SOPS_AGE_KEY_FILE}} | kubectl -n flux-system create secret generic sops-age --from-file=age.agekey=/dev/stdin

create_cluster_secrets:
    sops --decrypt {{KUBERNETES_DIR}}/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -

create_cluster_settings:
    kubectl apply -f {{KUBERNETES_DIR}}/flux/vars/cluster-settings.yaml

create_flux_config:
    kubectl apply --kustomize {{KUBERNETES_DIR}}/flux/config

# install the cluster
bootstrap_cluster: install_flux create_age_key_secret create_cluster_secrets create_cluster_settings create_flux_config