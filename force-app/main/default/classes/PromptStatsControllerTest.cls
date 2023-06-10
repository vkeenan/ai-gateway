@isTest
public class PromptStatsControllerTest {
	@isTest
	static void testPromptStatsController() {
		// Prepare test data
		// Insert test Prompts
		List<Prompt__c> testPrompts = new List<Prompt__c>();
		List<PromptAnswer__c> testPromptAnswers = new List<PromptAnswer__c>();

		for (Integer i = 0; i < 5; i++) {
			testPrompts.add(new Prompt__c(
						// Assume you have Name field
						// You should replace this with actual field names and data for your Prompt__c object
						Name = 'Test Prompt ' + i
						));
		}

		insert testPrompts;

		// Insert test Prompt Answers

		for (Integer i = 0; i < 7; i++) {
			testPromptAnswers.add(new PromptAnswer__c(
						      // Assume you have Name field
						      // You should replace this with actual field names and data for your PromptAnswer__c object
						      Prompt__c = testPrompts[0].Id,
						      Name = 'Test Prompt Answer ' + i
						      ));
		}

		insert testPromptAnswers;

		Test.startTest();
		// Create an instance of the controller
		PromptStatsController controller = new PromptStatsController();
		Test.stopTest();

		// Verify the results
		System.assertEquals(5, controller.totalPrompts, 'Total prompts should match the number of inserted prompts');
		System.assertEquals(7, controller.totalAnswers, 'Total answers should match the number of inserted prompt answers');
	}

}
