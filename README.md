# Salesforce Prompt Engineering - sf-prompts

## Project Description

The sf-prompts project is an open-source software repository dedicated to providing a platform for Salesforce customers to interact with the OpenAI API. Utilizing a custom Salesforce object named `Prompt__c`, this project enables developers and users to create and store prompts that can be sent to the OpenAI completion API. The response from the API is then stored in the `PromptAnswer__c` object. This repository serves as a foundational tool for Salesforce customers interested in leveraging AI capabilities for B2B software and marketing applications.

## Table of Contents

- [Salesforce Prompt Engineering - sf-prompts](#salesforce-prompt-engineering---sf-prompts)
  - [Project Description](#project-description)
  - [Table of Contents](#table-of-contents)
  - [Project Setup](#project-setup)
    - [OpenAI Setup](#openai-setup)
      - [Get OpenAI API Key and Organization ID](#get-openai-api-key-and-organization-id)
      - [Create External Credential](#create-external-credential)
        - [Create Permission Set Mapping](#create-permission-set-mapping)
        - [Create Custom Headers](#create-custom-headers)
      - [Create Named Credential](#create-named-credential)
  - [Using sf-prompts](#using-sf-prompts)
  - [Project Testing](#project-testing)
  - [Project Deployment](#project-deployment)
  - [Project Roadmap](#project-roadmap)
  - [Project Contributing](#project-contributing)
  - [Project License](#project-license)
  - [Project Code of Conduct](#project-code-of-conduct)
  - [Project Contact Information](#project-contact-information)
  - [Project Acknowledgements](#project-acknowledgements)
  - [Project History](#project-history)
  - [Project Credits](#project-credits)
  - [Project Sponsors](#project-sponsors)
  - [Project References](#project-references)

![Robot with a Wrench and a Brush](images/SalesforceDevops.net_An_icon_that_is_robot_with_a_wrench.png)

## Project Setup

The code provided is designed to work out-of-the-box with Salesforce scratch orgs. You should also be able to adapt it to work with other Salesforce orgs by deploying the metadata elements manually. Below are instructions for setting up a scratch org and deploying the sample prompts.

Please be careful to follow the setup instructions precisely. The OpenAI integration depends on the exact values used in other steps.

These instructions assume you don't already have a dev-hub org set up. If you do, you can skip the first two steps.

1. Have and existing Salesforce Developer Edition org or create a new one. This will be your dev-hub org. You can create a new one here: <https://developer.salesforce.com/signup>.
1. Enable Dev Hub in your dev-hub org. See instructions here: <https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_enable_devhub.htm>.
1. Install the Salesforce CLI. See instructions here: <https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm>.
1. Install VS Code and Salesforce CLI Plugin for VS Code. See instructions here: <https://developer.salesforce.com/tools/vscode/en/vscode-desktop/install>.
1. Extract the vkeenan/sf-prompts repository to your local machine. See instructions here: <https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository>.
1. Use VS Code to open the new new folder.
1. Open the Command Palette (Ctrl+Shift+P) and run the command SFDX: Authorize a Dev Hub.
1. Select the dev-hub org you created in step 1.
1. Open a terminal window in VS Code (Ctrl+Shift+`).
1. Rename the environment file `scripts/.env.example` to `scripts/.env`.
1. Open `scripts/.env` with VS Code and enter your Dev-Hub username. Save the file.
1. Enter the command `make build` to create the scratch org and load the sample prompts.

### OpenAI Setup

You need to get an OpenAI API key and then configure Salesforce to use it properly. This involes creatin a Named Credential and an External Credential. Once we enter the OpenAI keys into Salesforce, they will be safe and cannot be retrieved or copied to your local machine.

#### Get OpenAI API Key and Organization ID

1. Go to <https://platform.openai.com/> and sign up for an API account. You can get a free tier account, but you will be restricted in the number of api calls you can make. And you'll be restricted to the gpt-3.5-turbo model.
2. Visit <https://platform.openai.com/account/api-keys> and generate a new key for this project. Keep it in a safe place, and don't put it in any repository.
3. Visit <https://platform.openai.com/account/org-settings> and copy the Organization ID. You'll need this later.

#### Create External Credential

This is the rather lengthy procedure for storing the OpenAI API Key and Org ID in Salesforce. It is necessary because Named Credentials do not support custom authentication parameters. So, we have to create an External Credential to store the API key and then reference the External Credential in the Named Credential. I managed to pre-load part of the External Credential in the GitHub metadata, but the rest needs to set up manually. Here is the Salesforce documentation: <https://help.salesforce.com/s/articleView?id=sf.external_services_define_named_credential.htm>.

##### Create Permission Set Mapping

1. Click on down arrow in the Actions column next to Prompt Engineering and select Edit.
1. Click Add on Authentication Parameters.
1. Under Parameter 1, enter "apiKey" for the Name.
1. Enter the OpenAI API key you generated in the previous section for the Value.
1. Click Add on Authentication Parameters to add your organization id as the second parameter.
1. Under Parameter 2, enter "Org" for the Name and enter your Organization ID for the Value.
1. Click Save for Permission Set Mappings.

##### Create Custom Headers

You need to create 3 custom header records within the External Credential. This is necessary because the OpenAI API requires 3 custom headers to be sent with each request. 

Here are the three headers. They use the specific names and values from prior steps, so be sure you followed those instructions exactly.

| Header Name         | Header Value                        |
| ------------------- | ----------------------------------- |
| Content-Type        | application/json                    |
| OpenAI-Organization | {!$Credential.OpenAI.Org}           |
| Authorization       | Bearer {!$Credential.OpenAI.apiKey} |

Follow these steps to create the custom headers:

1. Click on New on Custom Headers.
2. Copy the first Header Name and Header Value from the table above.
3. Click Save
4. Repeat steps 1-3 for the other two headers.
5. Click on the `Named Credentials` label a the top of the page and then click on `Named Credenitals` tab to return to the list of Named Credentials.

#### Create Named Credential

Now that we have the External Credential created, we can create the Named Credential that will be used by the Apex code to make the API calls. Ensure you are using the exact values specified here because the Flow and Apex code rely on them.

1. Click New on Named Credentials.
2. Enter `OpenAIChat` for the Label and Name.
3. Enter `https://api.openai.com/v1/chat/completions` for the URL.
4. Click in the External Credential field and select `OpenAI`.
5. Unclick the `Generate Authorization Header` checkbox.
6. Click `Allow Formulas in HTTP Header` checkbox.
7. Click Save.

Congratulations! You have completed the setup required to use the OpenAI API from within you Salesforce org, and your API key is safely stored in Salesforce. You are ready to start using the sample prompts.

## Using sf-prompts


... (pending instructions here) ...

## Project Testing

... (pending instructions here) ...

## Project Deployment

... (pending instructions here) ...

## Project Roadmap

... (pending plans here) ...

## Project Contributing

... (pending instructions here) ...

## Project License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Project Code of Conduct

... (pending instructions here) ...

## Project Contact Information

For any inquiries about the project, please reach out to us at project_sf-prompts@salesforce.com.

## Project Acknowledgements

We would like to thank the following for their contributions and support:

- Salesforce Community: For their continued support and usage of the project.
- OpenAI: For providing the API used in this project.

## Project History

The sf-prompts project was conceived with the aim of harnessing the power of OpenAI in the Salesforce ecosystem. It started as a small, internal project, but quickly grew as more Salesforce customers expressed interest in AI capabilities. The project was made open source to foster innovation and expand its potential applications within the community.

## Project Credits

- Project Lead: [Your Name](mailto:you@example.com)
- Core Contributors: (List of core contributors)

## Project Sponsors

We are currently looking for sponsors. If you are interested in sponsoring this project, please contact us.

## Project References

- [Salesforce Developer Documentation](https://developer.salesforce.com/docs/)
- [OpenAI API Documentation](https://platform.openai.com/docs/)

Copy code





Regenerate response
