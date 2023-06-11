# AI Gateway for Salesforce

`AI Gateway for Salesforce` allows Salesforce customers to generate text with OpenAI API directly within Salesforce. The prompts and answers are stored in Salesforce custom objects. A remarkably powerful tool, `AI Gateway for Salesforce` allows small teams to begin experimenting with zero-shot prompt engineering in everyday productivity tasks.

The project is available as an unmanaged package on the Salesforce AppExchange: <https://appexchange.salesforce.com/appxListingDetail?listingId=xxx>

You can also use this repository to deploy the project to a Salesforce scratch org for testing and development.

![Robot with a Wrench and a Brush](images/SalesforceDevops.net_An_icon_that_is_robot_with_a_wrench.png)

[![GitHub release](https://img.shields.io/github/release/vkeenan/ai-gateway.svg)]

## Project Description

`AI Gateway for Salesforce` is an open-source project for Salesforce customers that allows their admins and developers to interact with OpenAI API. Utilizing a custom Salesforce object named `Prompt__c`, this project enables developers and users to create and store prompts that can be sent to the OpenAI chat completions API using the `gpt-4` and `gpt-3.5-turbo` models. The response from the API is then stored in the `PromptAnswer__c` object. This repository serves as a foundational tool for Salesforce customers interested in leveraging AI capabilities for B2B software and marketing applications.

`AI Gateway for Salesforce` is a bare-bones implementation of OpenAI API. It is intended to be a template for other organizations to being experimenting with OpenAI API. The OpenAI user interface is written is a very simple Flow, so it should be easy for admins and developers to customize the user interface to meet their needs.

## Privacy Considerations

You need to make your own decision whether to used OpenAI API because it requires sending data to the Open AI servers. However, if you believe OpenAI's promises, then it should be safe. Here are some of the promises presented in the latest update to their privacy policy: <https://openai.com/policies/privacy-policy>.

1. OpenAI will not use customer data submitted via the API to train or improve their models unless the customer explicitly opts in to share their data for this purpose.
2. Data sent through the API will be retained for a maximum of 30 days for abuse and misuse monitoring purposes, after which it will be deleted (unless required by law).
3. Unlike ChatGPT-4, where saved conversations are used to improve the model, the API does not save conversations.

Here is some more information from OpenAI: "By default, OpenAI does not use customer data submitted via the API to train their models or improve their services. Data submitted for fine-tuning is only used to fine-tune the customer's model. OpenAI retains API data for 30 days for abuse and misuse monitoring purposes, and a limited number of authorized employees and third-party contractors can access this data solely for investigating and verifying suspected abuse. Data submitted through the Files endpoint, such as for fine-tuning a model, is retained until the user deletes the file."

Bottom line: according to these promises your data will not be saved and used for training. But, I would recommend that you read the OpenAI privacy policy and make your own decision about whether you want to use this project in your own org. As of Summer, 2023 we are still waiting for the OpenAI Business account to be available. I believe OpenAI will be able to provide more assurances about data privacy once the Business account is available.

## Table of Contents

- [AI Gateway for Salesforce](#ai-gateway-for-salesforce)
  - [Project Description](#project-description)
  - [Privacy Considerations](#privacy-considerations)
  - [Table of Contents](#table-of-contents)
  - [Unmanaged Package Post-Installation Notes](#unmanaged-package-post-installation-notes)
  - [Local Project Setup](#local-project-setup)
    - [OpenAI Setup](#openai-setup)
      - [Get OpenAI API Key and Organization ID](#get-openai-api-key-and-organization-id)
    - [Salesforce Setup](#salesforce-setup)
      - [Edit Permission Set Mapping](#edit-permission-set-mapping)
  - [Using AI Gateway for Salesforce](#using-ai-gateway-for-salesforce)
  - [License](#license)
  - [Project Contact Information](#project-contact-information)
  - [Project Acknowledgements](#project-acknowledgements)
  - [Project History](#project-history)
  - [Project Credits](#project-credits)
  - [Project Sponsors](#project-sponsors)
  - [Project References](#project-references)

## Unmanaged Package Post-Installation Notes

After installing the unmanaged package, you will need to do some additional setup to get the project working. The unmanaged package does not include the OpenAI API keys, so you will need to enter them manually. You will also need to set up the permission sets and permission set assignments. Navigate to the Prompt Engineering app and follow the post-installation instructions. Don't forget to assign designated users to the `PromptEngineering` permission set.

You can also load the sample prompts in this repository to your org. Copy the `Prompt__c.json` document in the `./data` folder to your local machine. Then use the Salesforce CLI to load the data into your org. Use the following command:

```bash
sfdx data import tree -f ./data/Prompt__c.json --target-org <your-org-alias> 
```

## Local Project Setup

The code provided is designed to work out-of-the-box with Salesforce scratch orgs. You should also be able to adapt it to work with other Salesforce orgs by deploying the metadata elements manually. Below are instructions for setting up a scratch org and deploying the sample prompts.

### OpenAI Setup

You need to get an OpenAI API key and then configure Salesforce to use it properly. This involes creating a Named Credential and an External Credential. Once we enter the OpenAI keys into Salesforce, they will be safe and cannot be retrieved or copied to your local machine.

#### Get OpenAI API Key and Organization ID

To use `AI Gateway for Salesforce` you will need an OpenAI API key and Organization ID. You can get these by following these steps:

1. Go to <https://platform.openai.com/> and sign up for an API account. You can get a free tier account, but you will be restricted in the number of api calls you can make. And you'll be restricted to the `gpt-3.5-turbo` model.
2. Visit <https://platform.openai.com/account/api-keys> and generate a new key for this project. Keep it in a safe place, and don't put it in any repository.
3. Visit <https://platform.openai.com/account/org-settings> and copy the Organization ID. You'll need this later.

### Salesforce Setup

These scratch org instructions assume you don't already have a dev-hub org set up. If you do, you can skip the first two steps.

1. You need to have an Salesforce Developer Edition org or create a new one. This will be your `dev-hub` org. You can create a new one here: <https://developer.salesforce.com/signup>.
1. Enable Dev Hub in your `dev-hub` org. See instructions here: <https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_enable_devhub.htm>.
1. Install the Salesforce CLI. See instructions here: <https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm>.
1. Install VS Code and Salesforce CLI Plugin for VS Code. See instructions here: <https://developer.salesforce.com/tools/vscode/en/vscode-desktop/install>.
1. Extract the <https://github.com/vkeenan/ai-gateway> repository to your local machine. See instructions here: <https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository>.
1. Use VS Code to open the `ai-gateway` folder.
1. Rename the environment file `scripts/.env.example` to `scripts/.env`.
1. Open the file `scripts/.env` with VS Code and enter your dev-hub username. Save the file.
1. Open a terminal window in VS Code (Ctrl+Shift+`).
1. Enter the command `make build` to create the scratch org and load the sample prompts.

#### Edit Permission Set Mapping

1. From the VS Code terminal, enter the command `make open` to go to the scratch org setup page.
2. Enter "named" in the Quick Find box and select Named Credentials.
3. Click on the External Credentials tab.
4. Click on the OpenAI item to edit its details.
5. Click on down arrow in the Actions column next to `PromptEngineering` and select Edit.
6. Click Add on Authentication Parameters.
7. Under Parameter 1, enter "apiKey" for the Name.
8. Enter the OpenAI API key you generated in the previous section for the Value.
9. Click Add on Authentication Parameters to add your organization id as the second parameter.
10. Under Parameter 2, enter "Org" for the Name and enter your Organization ID for the Value.
11. Click Save for Permission Set Mappings.

Congratulations! You have completed the setup required to use the OpenAI API from within you Salesforce org, and your API key is safely stored in Salesforce. You are ready to start using the sample prompts.

## Using AI Gateway for Salesforce

Once you have everything set up you can begin sending prompts to OpenAI. Navigate to the Prompts tab and click New to create a new prompt. Enter a name and title for the prompt and then select the model you want to use. 

You should then enter a System Messaage and User Message. Here is the difference between the two:

- **System Message**: This is the message that will be sent to OpenAI. It should be a short message that describes the context of the prompt. You might enter "I am a customer service agent. I am helping a customer with a problem." This message will be sent to OpenAI as the first part of the prompt and generally does not vary between prompts.
- **User Message**: If you have a system message, the user message can be a short message with a request, or it could be a longer message that includes source material. For example, you could enter "Please summarize the sentiment and intent of the customer in this chat session." Then, when you execute this prompt you would paste in the chat session. The system message would be the same, but the user message would change depending on the chat session.

## License

This project is licensed under the terms of the MIT license. For more details, see the [LICENSE](./LICENSE) file.

## Project Contact Information

For any inquiries about the project, please reach out to me at `vern@salesforcedevops.net` or <https://linkedin.com/in/vernonkeenan>.

## Project Acknowledgements

We would like to thank the following for their contributions and support:

- Salesforce Community: For their continued support and usage of the project.
- OpenAI: For providing the API used in this project.
- [From Andre Tawalbeh: Tap into the Power of ChatGPT via Flow](https://unofficialsf.com/tap-into-the-power-of-chatgpt-via-flow/)

## Project History

The AI Gateway for Salesforce project was conceived with the aim of harnessing the power of OpenAI in the Salesforce ecosystem. It started as a small, internal project, but quickly grew as more Salesforce customers expressed interest in AI capabilities. The project was made open source to foster innovation and expand its potential applications within the community.

## Project Credits

- Project Lead: [Your Name](mailto:you@example.com)
- Core Contributors: (List of core contributors)

## Project Sponsors

We are currently looking for sponsors. If you are interested in sponsoring this project, please contact us.

## Project References

- [Salesforce Developer Documentation](https://developer.salesforce.com/docs/)
- [OpenAI API Documentation](https://platform.openai.com/docs/)
