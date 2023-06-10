@isTest
global class OpenAIHttpCalloutMock implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
		// Create a fake response
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"id": "1", "object": "object", "created": 1641234123, "model": "gpt-3.5-turbo", "usage": {"prompt_tokens": 10, "completion_tokens": 10, "total_tokens": 20}, "choices": [{"message": {"role": "assistant", "content": "The weather is sunny."}, "finish_reason": "stop", "index": 0}]}');
		res.setStatusCode(200);
		return res;
	}

}
