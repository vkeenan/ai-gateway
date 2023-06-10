@isTest
public class OpenAIConnectTest {
	@isTest static void testConnect() {
		// Set up your test data
		List<OpenAIConnect.openAiInputs> inputs = new List<OpenAIConnect.openAiInputs>();
		OpenAIConnect.openAiInputs testInput = new OpenAIConnect.openAiInputs();
		testInput.promptParameters = '{"placename": "San Francisco"}';
		testInput.openaiSystem = 'You are a helpful assistant.';
		testInput.openaiChatHistory = '';
		testInput.openaiPrompt = 'What is the weather like in {placename} today?';
		testInput.settingsModel = '';
		testInput.settingsTokens = null;
		testInput.settingsTemperature = null;
		testInput.settingsEndpoint = 'OpenAI_Endpoint';
		inputs.add(testInput);

		// Prepare the test for the HttpRequest
		Test.setMock(HttpCalloutMock.class, new OpenAIHttpCalloutMock());

		// Test the method
		Test.startTest();
		List<OpenAIConnect.openAiOutputs> outputs = OpenAIConnect.connect(inputs);
		Test.stopTest();

		// Validate the outputs
		System.assertEquals(1, outputs.size(), 'Expected 1 output');
		OpenAIConnect.openAiOutputs output = outputs[0];

		System.assertEquals('1', output.replyID, 'Expected replyID to match');
		System.assertEquals('object', output.openAiObject, 'Expected object type to match');
		System.assertEquals('gpt-3.5-turbo', output.openAiModel, 'Expected model to match');
		System.assertEquals(20, output.tokensUsed, 'Expected tokens used to match');
		System.assertEquals('stop', output.finishReason, 'Expected finish reason to match');
		System.assertEquals('The weather is sunny.', output.openAiTextOutput, 'Expected first line of chat reply to match');
	}

}
