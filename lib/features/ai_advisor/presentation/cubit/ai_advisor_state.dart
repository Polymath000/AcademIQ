abstract class AiAdvisorState {}

class AiAdvisorInitial extends AiAdvisorState {}

class AiAdvisorLoading extends AiAdvisorState {}

class AiAdvisorLoaded extends AiAdvisorState {
  final String analysisResult;

  AiAdvisorLoaded(this.analysisResult);
}

class AiAdvisorError extends AiAdvisorState {
  final String message;

  AiAdvisorError(this.message);
}
