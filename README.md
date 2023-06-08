# Salesforce Prompt Engineering - sf-prompts

## Project Setup

The code provided is designed to work out-of-the-box with Salesforce scratch orgs. You should also be able to adapt it to work with other Salesforce orgs by deploying the metadata elements manually.

### Initial Setup

Here are complete setup instructions. This assumes you don't already have a dev-hub org set up. If you do, you can skip the first two steps.

1. Have and existing Salesforce Developer Edition org or create a new one. This will be your dev-hub org. You can create a new one here: https://developer.salesforce.com/signup.
2. Enable Dev Hub in your dev-hub org. See instructions here: <https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_enable_devhub.htm>.
3. Install the Salesforce CLI. See instructions here: <https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm>.
5. Install VS Code and Salesforce CLI Plugin for VS Code. See instructions here: <https://developer.salesforce.com/tools/vscode/en/vscode-desktop/install>.
6. Extract the vkeenan/sf-prompts repository to your local machine. See instructions here: <https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository>.
7. Open VS Code to the new directory.
8. Open the Command Palette (Ctrl+Shift+P) and run the command SFDX: Authorize a Dev Hub.
9. Select the dev-hub org you created in step 1.
10. Open a terminal window in VS Code (Ctrl+Shift+`).
11. Rename the environment file with `mv scripts/.env.example scripts/.env`.
12. Open `scripts/.env` andenter your enter your Dev-Hub username.
13. Run the command `make build` to create the scratch org and load new data.

### OpenAI Setup

You first need to get an OpenAI API key and then configure Salesforce to use it properly. This involes create a Named Credential and an External Credential. Once we enter the OpenAI keys into Salesforce, they will be safe and cannot be retrieved.

#### Get OpenAI API Key and Organization ID

1. Go to <https://platform.openai.com/> and sign up for an API account. You can get a free tier account, but you will be restricted in the number of api calls you can make. And you'll be restricted to the davinci-003 model.
2. Visit <https://platform.openai.com/account/api-keys> and generate a new key for this project. Keep it in a safe place, and don't put it in any repository.
3. Visit <https://platform.openai.com/account/org-settings> and copy the Organization ID. You'll need this later.

#### Create External Credential

This is the rather lengthy procedure for storing the OpenAI API Key in Salesforce. It is necessary because Named Credentials do not support custom authentication parameters. So, we have to create an External Credential to store the API key and then reference that credential in the Named Credential. Here is the Salesforce documentation: <https://help.salesforce.com/s/articleView?id=sf.external_services_define_named_credential.htm>.

##### Begin Creating External Credential

1. Open your scratch org. Use the command `make open` to open the scratch org in your browser.
2. Enter "named" in the Setup Quick Find box and select Named Credentials.
3. Click External Credentials.
4. Click New External Credential.
5. Enter "OpenAI" for the Label and Name.
6. Select "Custom" for Authentication Protocol.
7. Click Save.

##### Create Permission Set Mapping

1. Click on new new OpenAI credential you just created.
1. Click New on Permission Set Mappings.
1. Click in the Permission Set field and then pick the "Prompt Engineering" permission set.
1. Leave Sequence Number and Identity Type as-is.
1. Click Add on Authentication Parameters.
1. Under Parameter 1, enter "apiKey" for the Name.
1. Enter the OpenAI API key you generated in the previous section for the Value.
1. Click Add on Authentication Parameters to add your organization id as the second parameter.
1. Under Parameter 2, enter "Org" for the Name and enter your Organization ID for the Value.
1. Click Save for Permission Set Mappings.

##### Create Custom Headers

We need to create 3 custom header records within the External Credential. This is necessary because the OpenAI API requires 3 custom headers to be sent with each request. Here are the three headers. They use the specific names and values from prior steps, so be sure you followed those instructions exactly.

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

Congratulations! You have completed the extra setup required to use the OpenAI API from within you Salesforce org.
