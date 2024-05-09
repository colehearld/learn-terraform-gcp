# Google Cloud Metadata Startup Script with Terraform

## Prerequisites

- **Install Terraform**: Ensure that Terraform is installed on your machine. If you don't have Terraform installed, download and install it from the [official Terraform website](https://www.terraform.io/downloads.html).
  
- **Google Cloud Account**: Make sure you have a Google Cloud account. If you do not have one, you can sign up at [Google Cloud](https://cloud.google.com/).

- **GCP Project**: Have a GCP project created and selected for your resources.

- **Service Account Key**: Create a service account key in your GCP project and download the JSON key file.

## Configuration Steps

### Prepare Terraform Configuration File

1. Create a new directory for your Terraform project.
2. Place the Terraform configuration code into a file named `main.tf` inside this directory.

### Update the Terraform Configuration

1. Replace `"your-project-id"` with your GCP project ID.
2. Replace `"Path/To/your-key.json"` with the path to your downloaded service account key file.

### Initialize Terraform

1. Open a terminal and navigate to the directory containing your `main.tf` file.
2. Run the following command to initialize the Terraform workspace:
    ```bash
    terraform init
    ```
   This command downloads and installs the Google Cloud provider plugin required for the operation.

### Plan Terraform Deployment

1. In the same directory, run the following command to see what resources Terraform plans to create:
    ```bash
    terraform plan
    ```
   This command shows a preview of what Terraform will do based on your `main.tf` configuration.

### Apply Terraform Configuration

1. If you are satisfied with the plan, apply the configuration to create the resources in GCP:
    ```bash
    terraform apply
    ```
   Terraform will ask for confirmation before proceeding. Type `yes` and press `ENTER` to confirm and start the deployment.

### Access Your Resources

1. After the `terraform apply` command completes, the infrastructure specified in your `main.tf` file will be created.
2. Use the Google Cloud Console or Google Cloud SDK to verify the creation of the resources.
3. The output `ad_ip_address` will display the public IP address assigned to your compute instance.

## Post-Deployment

- SSH into your VM using the external IP and the SSH key associated with your GCP account. You can also access the instance directly on the Google Cloud Console.
- When you no longer need the resources, you can destroy them by running:
    ```bash
    terraform destroy
    ```
    This will remove all resources defined in your Terraform configuration from your GCP project. Confirm with `yes` when prompted.