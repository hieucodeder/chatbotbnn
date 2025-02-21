class BodySuggestion {
	String? query;
	String? prompt;
	String? genmodel;

	BodySuggestion({this.query, this.prompt, this.genmodel});

	BodySuggestion.fromJson(Map<String, dynamic> json) {
		query = json['query'];
		prompt = json['prompt'];
		genmodel = json['genmodel'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['query'] = this.query;
		data['prompt'] = this.prompt;
		data['genmodel'] = this.genmodel;
		return data;
	}
}
