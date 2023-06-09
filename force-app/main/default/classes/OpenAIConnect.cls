/**
 * OpenAIConnect Class
 *
 * @description This class provides a connection to the OpenAI API.
 * It allows sending prompts to OpenAI, and handles the responses
 * received from OpenAI, parsing the data into a usable format for Salesforce.
 *
 * Main functionality:
 * - Prepares the prompts before sending to OpenAI API
 * - Sends a HTTP request to OpenAI API with the appropriate prompts and settings
 * - Parses the HTTP response from OpenAI API, extracting key information such as
 *   the generated text, finish reason, response ID and tokens used.
 * - Returns a list of outputs containing key information for each input prompt.
 *
 * Usage:
 * An instance of this class is not needed. It exposes a static method "connect"
 * which can be called with a list of "openAiInputs" objects. The method returns
 * a list of "openAiOutputs" objects, each corresponding to an input prompt.
 *
 * Example:
 * List<OpenAIConnect.openAiInputs> inputs = new List<OpenAIConnect.openAiInputs>();
 * List<OpenAIConnect.openAiOutputs> outputs = OpenAIConnect.connect(inputs);
 *
 * Notes:
 * Make sure to handle potential exceptions when calling the "connect" method,
 * especially when network issues might occur or when the input prompts are not valid.
 *
 * Using OpenAIConnect with Salesforce Flow
 *
 * Salesforce Flows provide a visual way of representing and customizing complex business
 * processes. OpenAIConnect can be used within a Flow to facilitate interaction with
 * the OpenAI API as part of these processes.
 *
 * Here's a basic step-by-step guide on how to use OpenAIConnect with a Flow:
 *
 * 1. Begin by creating a new Flow in Salesforce. In your Salesforce Setup,
 *    navigate to Flows and click on "New Flow".
 *
 * 2. Choose the Flow type that suits your needs, generally a Record-Triggered or
 *    Scheduled-Triggered Flow will be used.
 *
 * 3. In the Flow Builder, you'll need to create a new Action. This action will
 *    represent the call to OpenAIConnect.connect method.
 *
 * 4. Search for and select the "OpenAIConnect" Apex Class and the "connect" method.
 *    A set of input and output variables corresponding to the "openAiInputs" and
 *    "openAiOutputs" will be generated.
 *
 * 5. Set the necessary input fields. These fields can be set to static values,
 *    or they can be populated dynamically based on other aspects of the Flow.
 *
 * 6. Save the Action and use the Flow Builder to define what should happen with
 *    the outputs. For instance, you could create a Record with the OpenAI's
 *    generated response, or send an Email with its contents.
 *
 * 7. Complete the Flow by setting the necessary conditions and actions, then
 *    Save and Activate the Flow.
 *
 * Note: Be sure to handle potential exceptions and errors in the Flow, as network
 * issues might occur or the input prompts might not be valid.

 */
public class OpenAIConnect {
	private static final Decimal DEFAULT_TEMPERATURE = 0.1;
	private static final Integer DEFAULT_TOKENS = 1700;
	private static final String DEFAULT_SYSTEMPROMPT = 'You are a helpful assistant.';
	private static final String DEFAULT_MODEL = 'gpt-3.5-turbo';

	@invocableMethod
	public static List <openAiOutputs> connect(List<openAiInputs> inputs) {
		// defines the output list
		List<openAiOutputs> outputs = new List<openAiOutputs>();

		for (openAiInputs curInput : inputs) {
			String chatHistory = curInput.openaiChatHistory;
			String systemPrompt = curInput.openaiSystem;
			String prompt = curInput.openaiPrompt; // required
			String promptParameters = curInput.promptParameters;
			String model = curInput.settingsModel;
			Integer tokens = curInput.settingsTokens;
			Double temperature = curInput.settingsTemperature;
			String endpoint = curInput.settingsEndpoint;
			openAiOutputs output = new openAiOutputs();
			String openAiTextOutput = '';
			String openAiMessage = '';
			String finishReason = '';
			String replyID = '';
			Integer tokensUsed = 0;

			// Substitute parameters in prompt
			// promptParameters is a JSON string with key/value pairs
			if (promptParameters != '' && promptParameters != null) {
				Map<String, String> mapJson;
				try {
					mapJson = (Map<String, String>)JSON.deserialize(promptParameters, Map<String, String>.class);
				}
				catch (Exception e) {
					system.debug('Error parsing Prompt Parameter JSON: ' + e);
				}

				for (String key : mapJson.keySet()) {
					String value = mapJson.get(key);
					prompt = prompt.replace('{' + key + '}', value);
				}
			}

			if (model == null || model == '') {
				model = DEFAULT_MODEL;
			}

			if (tokens < 0 || tokens > 4096 || tokens == null) {
				tokens = DEFAULT_TOKENS;
			}

			if (temperature < 0 || temperature > 1 || temperature == null) {
				temperature = DEFAULT_TEMPERATURE;
			}

			// Set up the system and user messages
			List<Map<String, String>> messages = new List<Map<String, String>>();

			// Add a system message if available
			if (systemPrompt != null && systemPrompt != '') {
				messages.add(new Map<String, String> {
					'role' => 'system',
					'content' => systemPrompt
				});
			} else if (chatHistory != null && chatHistory != '') {
				// Add the chat history
				List<Map<String, String>> chatHistoryList = (List<Map<String, String>>)JSON.deserialize(chatHistory, List<Map<String, String>>.class);

				for (Map<String, String> message : chatHistoryList) {
					messages.add(message);
				}
			} else {
				// Add a default system message
				messages.add(new Map<String, String> {
					'role' => 'system',
					'content' => DEFAULT_SYSTEMPROMPT
				});
			}

			// Add the user message
			messages.add(new Map<String, String> {
				'role' => 'user',
				'content' => prompt
			});

			// JSON generation for the new chat-based API format
			Map<String, Object> jsonBody = new Map<String, Object> {
				'model' => model,
				'messages' => messages,
				'temperature' => temperature,
				'max_tokens' => tokens
			};
			String postString = JSON.serialize(jsonBody);

			HttpRequest req = new HttpRequest();
			// set the endpoint to the endpoint defined in named credentials of Salesforce
			req.setEndpoint('callout:' + endpoint);
			// set the timeout to 3 minutes
			req.setTimeout(180000);
			// define POST for method endpoint
			req.setMethod('POST');
			// set the body of the request
			req.setBody(postString);
			system.debug('JSON body: ' + req.getBody());
			// create a new HTTP object
			Http http = new Http();
			// send the request
			HttpResponse res = http.send(req);

			// create a new JSON parser
			JSONParser parser = JSON.createParser(res.getBody());
			// create variables to store the reason for finishing and the reply ID

			// loop through the response
			while (parser.nextToken() != null) {
				// if the current token is a field name and the text is 'text'
				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
				    (parser.getText() == 'text')) {
					// Get the value.
					parser.nextToken();
					// Add the text to the output variable
					output.openAiTextOutput = EncodingUtil.urlDecode(parser.getText(), 'UTF-8');
				}

				// if the current token is a field name and the text is 'id'
				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
				    (parser.getText() == 'id')) {
					// Get the value.
					parser.nextToken();
					// Add the text to the output variable
					output.replyID = parser.getText();
				}

				// if the current token is a field name and the text is 'finish_reason'
				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
				    (parser.getText() == 'finish_reason')) {
					// Get the value.
					parser.nextToken();
					// Add the text to the output variable
					output.finishReason = parser.getText();
				}

				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
				    (parser.getText() == 'total_tokens')) {
					// Get the value.
					parser.nextToken();
					// Add the integer to the output variable
					output.tokensUsed = parser.getIntegerValue();
				}

				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
				    (parser.getText() == 'message')) {
					// Get the value.
					parser.nextToken();
					// Add the integer to the output variable
					openAiTextOutput = parser.getText();
				}
			}

			// Check the status code of the response
			if (res.getStatusCode() == 200) {
				System.debug('Response Body: ' + res.getBody());
				System.debug('ReplyID: ' + replyID);
				System.debug('finishReason: ' + finishReason);
				System.debug('tokensUsed: ' + tokensUsed);
			}
			else {
				output.openAiTextOutput = openAiMessage;
				System.debug('Error connecting to OpenAI: ' + res.getStatusCode() + '' + res.getStatus() + '' + res.getBody());
			}

			// add the output to the output list
			outputs.add(output);
		}

		// return the output list
		return outputs;
	}

	public static String preparePrompt(String prompt) {
		// Replace multiple consecutive whitespace characters (not including newlines) with a single space
		String promptWithSingleSpaces = prompt.replaceAll('\\s+', ' ');

		// Replace multiple consecutive newline characters with a single newline
		String minifiedPrompt = promptWithSingleSpaces.replaceAll('\\n+', '\n');

		// Remove lines that start with #, ##, or ###
		// String promptWithoutComments = minifiedPrompt.replaceAll('(?m)^\\s*#.*$', '');

		// URL encode the string for safe HTTP transmission
		String encodedPrompt = EncodingUtil.urlEncode(minifiedPrompt, 'UTF-8');

		return encodedPrompt;
	}

	public class openAiInputs {
		@InvocableVariable(required = false label = 'Prompt Parameters' description = 'Is a JSON body of the prompt parameters')
		public String promptParameters;
		@InvocableVariable(required = false label = 'Open AI System Prompt' description = 'Is the system prompt for what to do with the prompt text')
		public String openaiSystem;
		@InvocableVariable(required = false label = 'Open AI Chat History' description = 'Is the chat history')
		public String openaiChatHistory;
		@InvocableVariable(required = false label = 'Open AI Prompt' description = 'Is the prompt for the AI model')
		public String openaiPrompt;
		@InvocableVariable(required = false label = 'Open AI Model' description = 'Defines the model used of the AI.')
		public String settingsModel;
		@InvocableVariable(required = false label = 'Tokens' description = 'Maximum Tokens to be used.')
		public Integer settingsTokens;
		@InvocableVariable(required = false label = 'Temperature' description = 'Temperature of the model to be used.')
		public Double settingsTemperature;
		@InvocableVariable(required = false label = 'Open AI Endpoint Name' description = 'Named Credential to which you want to call.')
		public String settingsEndpoint;
	}

	public class openAiOutputs {
		@InvocableVariable(required = false label = 'Open AI Text Output' description = 'Provides the text response from OpenAI model as a String.')
		public String openAiTextOutput;
		@InvocableVariable(required = false label = 'ReplyId' description = 'ReplyID of the Ai response')
		public String replyID;
		@InvocableVariable(required = false label = 'Finish Reason' description = 'Reason the AI stopped responding')
		public String finishReason;
		@InvocableVariable(required = false label = 'Tokens Used' description = 'Amount of tokens used.')
		public Integer tokensUsed;
	}

}