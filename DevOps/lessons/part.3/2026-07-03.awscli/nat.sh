#!/bin/bash

set -e

PUBLIC_SUBNET_ID="subnet-0bf616fe6535824df"
PRIVATE_SUBNET_RT_ID="rtb-0d2646329a159b806"
NAT_GW_NAME="main-nat-gw"
ACTION=$1


function info() {
  local msg=$1
  echo "*** INFO | ${msg}"
}

function check_if_nat_gw_exists() {
  NAT_GW_ID=$(aws ec2 describe-nat-gateways \
    --filter "Name=tag:Name,Values=${NAT_GW_NAME}" \
    --filter "Name=state,Values=available" \
    --query "NatGateways[*].NatGatewayId" \
    --output text)

  echo ${NAT_GW_ID}

  if [ -n "${NAT_GW_ID}" ]; then
    info "NAT GW: ${NAT_GW_NAME} already exists! Exiting ..."
    exit 0
  fi
}

function create_nat_gw() {
  info "Creating Elastic IP (Static IP Address)"
  ALLOCATION_ID=$(aws ec2 allocate-address --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=${NAT_GW_NAME}}]" \
   | jq -r .AllocationId)
  info "Allocation ID: ${ALLOCATION_ID}"

  echo "================================================="

  info "Create NAT GW"
  NAT_GW_ID=$(aws ec2 create-nat-gateway \
    --subnet-id ${PUBLIC_SUBNET_ID} \
    --allocation-id ${ALLOCATION_ID} \
    --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=${NAT_GW_NAME}}]" \
    | jq -r .NatGateway.NatGatewayId)
  info "NAT GW ID: ${NAT_GW_ID}"

  info "Wait until NAT GW is ready"
  aws ec2 wait nat-gateway-available --nat-gateway-ids ${NAT_GW_ID}

  echo "================================================="

  info "Updating private subnet route table"
  aws ec2 replace-route \
    --route-table-id ${PRIVATE_SUBNET_RT_ID} \
    --destination-cidr-block 0.0.0.0/0 \
    --nat-gateway-id ${NAT_GW_ID}
}

function delete_nat_gw() {
  NAT_GW_ID=$(aws ec2 describe-nat-gateways \
    --filter "Name=tag:Name,Values=${NAT_GW_NAME}" \
    --filter "Name=state,Values=available" \
    --query "NatGateways[*].NatGatewayId" \
    --output text)
  info "NAT GW ID: ${NAT_GW_ID}"

  ALLOCATION_ID=$(aws ec2 describe-addresses \
    --filter "Name=tag:Name,Values=${NAT_GW_NAME}" \
    --query "Addresses[*].AllocationId" \
    --output text)
  info "ALLOCATION ID ${ALLOCATION_ID}"

  info "Deleting NAT GW"
  aws ec2 delete-nat-gateway --nat-gateway-id ${NAT_GW_ID}

  info "Wait until NAT GW is deleted"
  aws ec2 wait nat-gateway-deleted --nat-gateway-ids ${NAT_GW_ID}

  info "Deleting Elastic IP (Static IP Address)"
  aws ec2 release-address --allocation-id ${ALLOCATION_ID}

}

function main() {
  if [[ "${ACTION}" == "create" ]];then
    check_if_nat_gw_exists
    create_nat_gw
  elif [[ "${ACTION}" == "delete" ]];then
    delete_nat_gw
  else
    echo "Please specify first positional parameter as 'create' or 'delete'!"
    exit 1
  fi
}

main