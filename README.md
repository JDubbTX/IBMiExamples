# IBM i Examples

This project uses the IBM i Development Pack set of Base extensions.  Naming of examples in this repo utilize BOB naming conventions and provides metadata for building the project with Bob (Better Object Builder).  

While its not required to use Bob for building the examples, it is highly recommended.  Otherwise, all of the provided examples can be built manually using standard IBM i create commands.

## Prerequisites
1. An IBM i to connect to.  This repo was created on pub400.com, which is currently at IBM i OS 7.5, but should also works on 7.4.
- If you don't have an IBM i, get yourself a login at [pub400.com](https://pub400.com)
2. A home IFS directory on your IBM i
3. If you want to use the dev container, install VSCODE + docker
4. Bob metadata is provided. To build these examples with Bob, you must have the following
- Opensource bootstrap environment set up (requires QSECOFR authority)
- Install Bob (Requires QSECOFR authority).  This was done with Bob v

## Local Development Instructions (requires Bob)
Follow these instructions if you want to clone the project to your local machine and use the dev container, and use Code For IBM i's deployment capabilities to push to the i, and build with Bob.
1. Clone this project to a folder on your local PC, or WSL folder on your local PC.
2. 

## Remote Development instructions
Follow thse instructions if you want to clone the project to your IBM i's IFS and not use the dev container.

## Examples Provided
The following examples are provided.
1. MULTI1.PGM.CLLE - First method for multi-threading a job on the IBM i.  This method utilizes range values over a key ID field in a table (eg: SSN, custormer ID, etc).

