package argocd

import (
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"

	//"github.com/stretchr/testify/assert"
	"testing"
	"time"
)

func TestTerraform(t *testing.T) {
	//Terraform
	//Future Parallel
	//t.Parallel()
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
	})
	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)
	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	//K8s requires kind running local cluster or a k8s cluser
	k8sOptions := k8s.NewKubectlOptions("", "", "argocd")
	k8s.WaitUntilServiceAvailable(t, k8sOptions, "argocd-server", 30, 1*time.Second)
	argoService := k8s.GetService(t, k8sOptions, "argocd-server")
	assert.Equal(t, "argocd", argoService.Namespace)

	// add additional test here

	// url := fmt.Sprintf("http://%s", k8s.GetServiceEndpoint(t, options, service, 5000))
	// http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello world!", 30, 3*time.Second)

}
