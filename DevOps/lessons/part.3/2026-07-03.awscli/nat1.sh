#!/bin/bash

PUBLIC_SUBNET_ID="subnet-0bf616fe6535824df"
PRIVATE_SUBNET_RT_ID="rtb-0d2646329a159b806"
NAT_GW_NAME="main-nat-gw"

function info() {
  local msg=$1
  echo "*** INFO | ${msg}"
}

function check_if_nat_gw_exists() {
  NAT_GW=$(aws ec2 describe-nat-gateways \
    --filter "Name=tag:Name,Values=${NAT_GW_NAME}" \
    --query "NatGateways[*].NatGatewayId" \
    --output text)

  if [ -n "${NAT_GW}" ]; then
    info "NAT GW: ${NAT_GW_NAME} already exists! Exiting ..."
    exit 0
  fi
}

function create_nat_gw() {
  info "Creating Elastic IP (Static IP Address)"
  ALLOCATION_ID=$(aws ec2 allocate-address | jq -r .AllocationId)
  info "Allocation ID: ${ALLOCATION_ID}"

  echo "================================================="

  info "Create NAT GW"
  NAT_GW_ID=$(aws ec2 create-nat-gateway \
    --subnet-id ${PUBLIC_SUBNET_ID} \
    --allocation-id ${ALLOCATION_ID} \
    --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=${NAT_GW_NAME}]" \
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

function main() {
#  create_nat_gw
  check_if_nat_gw_exists
}

main