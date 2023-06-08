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
