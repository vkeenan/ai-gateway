# Salesforce Prompt Engineering - sf-prompts

![Robot with a Wrench and a Brush](images/SalesforceDevops.net_An_icon_that_is_robot_with_a_wrench.png)

[![GitHub release](https://img.shields.io/github/release/vkeenan/sf-prompts.svg)]

## Project Description

`sf-prompts` is an open-source software repository for Salesforce customers that allows their admins and developers to interact with the OpenAI API. Utilizing a custom Salesforce object named `Prompt__c`, this project enables developers and users to create and store prompts that can be sent to the OpenAI chat API using the `gpt-4` and `gpt-3.5-turbo` models. The response from the API is then stored in the `PromptAnswer__c` object. This repository serves as a foundational tool for Salesforce customers interested in leveraging AI capabilities for B2B software and marketing applications.

The intent of the project is to provide a simple, easy-to-use interface for Salesforce customers to interact with the OpenAI API. The project is designed to be deployed to a Salesforce scratch org and to be used by Salesforce administrators and developers. The project is not intended to be used by end users.

## Privacy Considerations

You need to make your own decision whether to used OpenAI API because it requires sending data to the Open AI servers. However, if you believe OpenAI's promises, then it should be safe. Here are some of the promises presented in the latest update to their privacy policy: <https://openai.com/policies/privacy-policy>.

1. OpenAI will not use customer data submitted via the API to train or improve their models unless the customer explicitly opts in to share their data for this purpose.
2. Data sent through the API will be retained for a maximum of 30 days for abuse and misuse monitoring purposes, after which it will be deleted (unless required by law).
3. Unlike ChatGPT-4, where saved conversations are used to improve the model, the API does not save conversations.

Here is some more information from OpenAI: "By default, OpenAI does not use customer data submitted via the API to train their models or improve their services. Data submitted for fine-tuning is only used to fine-tune the customer's model. OpenAI retains API data for 30 days for abuse and misuse monitoring purposes, and a limited number of authorized employees and third-party contractors can access this data solely for investigating and verifying suspected abuse. Data submitted through the Files endpoint, such as for fine-tuning a model, is retained until the user deletes the file."

Bottom line: according to these promises your data will not be saved and used for training. But, I would recommend that you read the OpenAI privacy policy and make your own decision about whether you want to use this project in your own org. As of Summer, 2023 we are still waiting for the OpenAI Business account to be available. I believe OpenAI will be able to provide more assurances about data privacy once the Business account is available.

## Table of Contents

- [Salesforce Prompt Engineering - sf-prompts](#salesforce-prompt-engineering---sf-prompts)
  - [Project Description](#project-description)
  - [Privacy Considerations](#privacy-considerations)
  - [Table of Contents](#table-of-contents)
  - [Project Setup](#project-setup)
    - [OpenAI Setup](#openai-setup)
      - [Get OpenAI API Key and Organization ID](#get-openai-api-key-and-organization-id)
    - [Salesforce Setup](#salesforce-setup)
      - [Edit Permission Set Mapping](#edit-permission-set-mapping)
  - [Using sf-prompts](#using-sf-prompts)
  - [Project Testing](#project-testing)
  - [Project Deployment](#project-deployment)
  - [Project Roadmap](#project-roadmap)
  - [Project Contributing](#project-contributing)
  - [License](#license)
  - [Project Code of Conduct](#project-code-of-conduct)
  - [Project Contact Information](#project-contact-information)
  - [Project Acknowledgements](#project-acknowledgements)
  - [Project History](#project-history)
  - [Project Credits](#project-credits)
  - [Project Sponsors](#project-sponsors)
  - [Project References](#project-references)

## Project Setup

The code provided is designed to work out-of-the-box with Salesforce scratch orgs. You should also be able to adapt it to work with other Salesforce orgs by deploying the metadata elements manually. Below are instructions for setting up a scratch org and deploying the sample prompts.

### OpenAI Setup

You need to get an OpenAI API key and then configure Salesforce to use it properly. This involes creating a Named Credential and an External Credential. Once we enter the OpenAI keys into Salesforce, they will be safe and cannot be retrieved or copied to your local machine.

#### Get OpenAI API Key and Organization ID

To use `sf-prompts` you will need an OpenAI API key and Organization ID. You can get these by following these steps:

1. Go to <https://platform.openai.com/> and sign up for an API account. You can get a free tier account, but you will be restricted in the number of api calls you can make. And you'll be restricted to the `gpt-3.5-turbo` model.
2. Visit <https://platform.openai.com/account/api-keys> and generate a new key for this project. Keep it in a safe place, and don't put it in any repository.
3. Visit <https://platform.openai.com/account/org-settings> and copy the Organization ID. You'll need this later.

### Salesforce Setup

These scratch org instructions assume you don't already have a dev-hub org set up. If you do, you can skip the first two steps.

1. You need to have an Salesforce Developer Edition org or create a new one. This will be your `dev-hub` org. You can create a new one here: <https://developer.salesforce.com/signup>.
1. Enable Dev Hub in your `dev-hub` org. See instructions here: <https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_enable_devhub.htm>.
1. Install the Salesforce CLI. See instructions here: <https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm>.
1. Install VS Code and Salesforce CLI Plugin for VS Code. See instructions here: <https://developer.salesforce.com/tools/vscode/en/vscode-desktop/install>.
1. Extract the <https://github.com/vkeenan/sf-prompts> repository to your local machine. See instructions here: <https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository>.
1. Use VS Code to open the `sf-prompts` folder.
1. Open the Command Palette (Ctrl+Shift+P or F1) and run the command SFDX: Authorize a Dev Hub.
1. Select the dev-hub org you created in step 1.
1. Rename the environment file `scripts/.env.example` to `scripts/.env`.
1. Open the file `scripts/.env` with VS Code and enter your dev-hub username. Save the file.
1. Open a terminal window in VS Code (Ctrl+Shift+`).
1. Enter the command `make build` to create the scratch org and load the sample prompts.

#### Edit Permission Set Mapping

1. From the VS Code terminal, enter the command `make open` to go to the scratch org setup page.
2. Enter "named" in the Quick Find box and select Named Credentials.
3. Click on the External Credentials tab.
4. Click on the OpenAI item to edit its details.
5. Click on down arrow in the Actions column next to `PromptEngineering_xxx` and select Edit.
6. Click Add on Authentication Parameters.
7. Under Parameter 1, enter "apiKey" for the Name.
8. Enter the OpenAI API key you generated in the previous section for the Value.
9. Click Add on Authentication Parameters to add your organization id as the second parameter.
10. Under Parameter 2, enter "Org" for the Name and enter your Organization ID for the Value.
11. Click Save for Permission Set Mappings.

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

## License

This project is licensed under the terms of the MIT license. For more details, see the [LICENSE](./LICENSE) file.

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
