/**
 * @description This class serves as a controller for retrieving statistics about Prompt records and PromptAnswer records.
 * It's generally used to display these statistics on a Visualforce page or a Lightning Component.
 *
 * The two main properties, `totalPrompts` and `totalAnswers`, represent the total count of records in `Prompt__c` and `PromptAnswer__c` respectively.
 */

public with sharing class PromptStatsController {
	public Integer totalPrompts {
		get; set;
	}
	public Integer totalAnswers {
		get; set;
	}

	public PromptStatsController() {
		totalPrompts = [SELECT count() FROM Prompt__c];
		totalAnswers = [SELECT count() FROM PromptAnswer__c];
	}

}
