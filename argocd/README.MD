# ArgoCD Terraform Module 

## How To Use

TBD

## How To Run Test
* Additional test coming, right now only demostrating 

* Pre-Reqs
    * Go
    * Terraform
    * A K8s cluster, prefere to use a local kind 

* Clone repo 
* switch dirs to the tests folder
    ```
    cd test
    pwd
    ```
    ```
    ➜  tests git:(main) ✗ terraform-modules/argocd/tests
    ```
* run "go mod tidy" , this will correct any missing packages needed
    ```
    go mod tidy
    ```
    ```
    ➜  tests git:(main) ✗ go mod tidy
    ```
* run tests with "go test", use optinal "-v" for full output 
    ```
    go test
    ```
    ```
    go test -v
    ```
    Should return
    ```
    ..... shorten for reading purposes, your output may be much larger
    TestTerraform 2021-09-27T12:17:52-04:00 logger.go:66: Destroy complete! Resources: 5 destroyed.
    TestTerraform 2021-09-27T12:17:52-04:00 logger.go:66: 
    PASS
    ok  	argocd	46.891s
    ```


### How to contribute
See root level README.md