# 🔏 Proof.im

Signature-based authentication as a service.

## Goals

- No private keys, ever!
- No passwords, ever!
- Proofs are independently cryptographically verifiable

## How It Works

1. Claim a handle
2. Upload a public key for that handle
3. Sign a claim that links the handle with the public key
4. Proof.im verifies the signature was signed by the corresponding private key
